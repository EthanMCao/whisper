//
//  ContentView.swift
//  whisper
//
//  Created by Ethan Cao on 4/25/25.
//

// ContentView.swift
// whisper
//
// Created by Ethan Cao on 4/25/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Username", text: $auth.username)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(white: 0.95))
                    .cornerRadius(8)

                SecureField("Password", text: $auth.password)
                    .padding()
                    .background(Color(white: 0.95))
                    .cornerRadius(8)

                Button("Log In") {
                    auth.login()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)

                NavigationLink("Don’t have an account? Sign Up", destination: SignUpView())
                    .font(.footnote)
                    .padding(.top, 8)
            }
            .padding()
            .navigationTitle("Welcome")
            // bind directly to the `showError` Bool + `errorMessage` String
            .alert(
                "Error",
                isPresented: $auth.showError,
                actions: { Button("OK") { auth.showError = false } },
                message: { Text(auth.errorMessage) }
            )
        }
    }
}

struct SignUpView: View {
    var body: some View {
        Text("Your sign‐up screen goes here")
    }
}


