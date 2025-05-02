// ChatView.swift
// whisper
//
// Created by Ethan Cao on 4/29/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    @State private var recipient: String = ""

    var body: some View {
        VStack {
            HStack {
                TextField("To (user)", text: $recipient)
                    .textFieldStyle(.roundedBorder)
                Button("Load") {
                    viewModel.fetch()
                }
            }
            .padding(.horizontal)

            List(viewModel.messages) { msg in
                HStack {
                    if msg.sender == viewModel.username {
                        Spacer()
                        Text(msg.content)
                            .padding()
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(8)
                    } else {
                        Text(msg.content)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        Spacer()
                    }
                }
            }

            HStack {
                TextField("Message…", text: $viewModel.draft)
                    .textFieldStyle(.roundedBorder)
                Button("Send") {
                    guard !recipient.isEmpty else { return }
                    viewModel.send(to: recipient)
                }
            }
            .padding()
        }
        .navigationTitle("Chat")
        .alert(item: Binding<AlertError?>(
            get: { viewModel.errorMessage.map { AlertError(message: $0) } },
            set: { _ in viewModel.errorMessage = nil }
        )) { err in
            Alert(
                title: Text("Error"),
                message: Text(err.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
