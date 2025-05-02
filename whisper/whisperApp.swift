//
//  whisperApp.swift
//  whisper
//
//  Created by Ethan Cao on 4/25/25.
//

// whisperApp.swift
import SwiftUI

@main
struct WhisperApp: App {
    // Our shared auth state
    @StateObject private var auth = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            // If we've got a token, show the Chat UI
            if let token = auth.token {
                NavigationView {
                    // Pass in a ChatViewModel that knows who we are and our token
                    ChatView(viewModel: ChatViewModel(
                        username: auth.username,
                        token: token
                    ))
                }
            } else {
                // Otherwise, show the login screen
                LoginView()
                    .environmentObject(auth)
            }
        }
    }
}
