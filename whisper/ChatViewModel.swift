// ChatViewModel.swift
// whisper
//
// Created by Ethan Cao on 4/29/25.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [MessageRead] = []
    @Published var draft: String = ""
    @Published var errorMessage: String?

    // Exposed so SwiftUI can read it
    let username: String
    private let token: String

    init(username: String, token: String) {
        self.username = username
        self.token = token
        fetch()
    }

    /// Load all messages for this user
    func fetch() {
        MyAPI.fetchMessages(for: username, token: token) { [weak self] (result: Result<[MessageRead], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let msgs):
                    self?.messages = msgs
                case .failure(let err):
                    self?.errorMessage = err.localizedDescription
                }
            }
        }
    }

    /// Send the current draft to a given recipient
    func send(to recipient: String) {
        let msg = MessageCreate(sender: username, recipient: recipient, content: draft)
        MyAPI.sendMessage(msg, token: token) { [weak self] (result: Result<MessageRead, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let sent):
                    self?.messages.append(sent)
                    self?.draft = ""
                case .failure(let err):
                    self?.errorMessage = err.localizedDescription
                }
            }
        }
    }
}
