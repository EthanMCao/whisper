//
//  MessageViewModel.swift
//  whisper
//
//  Created by Ethan Cao on 4/28/25.
//

import SwiftUI
import Combine

struct Message: Identifiable, Decodable {
    let id: Int
    let sender: String
    let recipient: String
    let content: String
    let timestamp: String
}

class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var error: String?
    
    private let baseURL = "http://localhost:8000"
    
    private var authToken: String? {
        UserDefaults.standard.string(forKey: "jwt")
    }
    
    func fetchMessages(for username: String) {
        guard let token = authToken,
              let url = URL(string: "\(baseURL)/messages/\(username)")
        else { return }
        
        var req = URLRequest(url: url)
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: req) { data, resp, err in
            DispatchQueue.main.async {
                if let err = err {
                    self.error = err.localizedDescription; return
                }
                guard let data = data,
                      let msgs = try? JSONDecoder().decode([Message].self, from: data)
                else {
                    self.error = "Failed to decode messages"
                    return
                }
                self.messages = msgs
            }
        }.resume()
    }
    
    func send(from sender: String, to recipient: String, content: String) {
        guard let token = authToken,
              let url = URL(string: "\(baseURL)/messages/send")
        else { return }
        
        let body = ["sender": sender, "recipient": recipient, "content": content]
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: req) { _, resp, err in
            DispatchQueue.main.async {
                if let err = err {
                    self.error = err.localizedDescription
                    return
                }
                // Refresh inbox after sending
                self.fetchMessages(for: sender)
            }
        }.resume()
    }
}
