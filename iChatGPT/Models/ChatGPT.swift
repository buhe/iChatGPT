//
//  ChatGPT.swift
//  iChatGPT
//
//  Created by HTC on 2022/12/8.
//  Copyright © 2022 37 Mobile Games. All rights reserved.
//

import Foundation
import Combine
import OpenAI

class Chatbot {
	var userAvatarUrl = "https://www.freelogovectors.net/wp-content/uploads/2023/01/chatgpt-logo-freelogovectors.net_.png"
    var openAIKey = ""
    var openAI:OpenAI
    var answer = ""
	
    init(openAIKey:String) {
        self.openAIKey = openAIKey
        self.openAI = OpenAI(apiToken: self.openAIKey)
	}
	


    
    func getUserAvatar() -> String {
        userAvatarUrl
    }


    func getChatGPTAnswer(prompts: [AIChat], completion: @escaping (String, Int) -> Void) {
        // 构建对话记录
        print("prompts")
        print(prompts)
        var messages: [OpenAI.Chat] = []
        for i in 0..<prompts.count {
            if i == prompts.count - 1 {
                messages.append(.init(role: "user", content: prompts[i].issue))
//                messages.append(.init(role: "system", content: "你是助手。"))
                break
            }
//            messages.append(.init(role: "user", content: prompts[i].issue))
            let answer = prompts[i].answer!
            if !answer.isEmpty {
//                messages.append(.init(role: "system", content: "You are a helpful assistant."))
                messages.append(.init(role: "assistant", content: answer))
                messages.append(.init(role: "user", content: prompts[i].issue))
            }
//            else {
//                messages.append(.init(role: "assistant", content: "你是个助手。"))
//
//            }
        }
        print("message:")
        print(messages)
        let query = OpenAI.ChatQuery(model: .gpt3_5Turbo, messages: messages, temperature: 0.8, max_tokens: 2048)
        openAI.chats(query: query) { data in
            print("data")
            print(data)
            do {
                let res = try data.get().choices[0].message.content
                let tokens = try data.get().usage.total_tokens
                DispatchQueue.main.async {
                    completion(res, tokens)
                }
            } catch {
                print(error)
//                let errorMessage = error.localizedDescription
                DispatchQueue.main.async {
                    completion("", 0)
                }
            }
        }
    }

}
