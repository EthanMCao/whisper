// LoginView.swift
// whisper
//
// Created by Ethan Cao on 4/29/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        VStack(spacing: 16) {
            TextField("Username", text: $auth.username)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $auth.password)
                .textFieldStyle(.roundedBorder)

            Button("Log In") {
                auth.login()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)

            HStack {
                Text("Don't have an account?")
                Button("Sign Up") {
                    // push your SignUpView here
                }
            }
            .font(.footnote)
        }
        .padding()
        // bind directly to the `showError` Bool and show `errorMessage`
        .alert(
            "Error",
            isPresented: $auth.showError,
            actions: {
                Button("OK") { auth.showError = false }
            },
            message: {
                Text(auth.errorMessage)
            }
        )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthViewModel())
    }
}
