//
//  AuthViewModel.swift
//  whisper
//
//  Created by Ethan Cao on 4/28/25.
//

//
//  AuthViewModel.swift
//  whisper
//
//  Created by Ethan Cao on 4/28/25.
//
// AuthViewModel.swift
// whisper
//
// Created by Ethan Cao on 4/28/25.
//

import Foundation

class AuthViewModel: ObservableObject {
    @Published var username     = ""
    @Published var password     = ""
    @Published var token: String?       // holds JWT on success

    // drives the alert:
    @Published var errorMessage = ""     // now a non‐optional String
    @Published var showError    = false  // Boolean flag for .alert(isPresented:)

    func login() {
        // 1) blank‐field guard
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill in both fields."
            showError = true
            return
        }

        // 2) call MyAPI.login(...) (from MyAPI.swift)
        MyAPI.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let jwt):
                    self?.token = jwt

                case .failure(let err):
                    self?.errorMessage = err.localizedDescription
                    self?.showError = true
                }
            }
        }
    }

    func loadToken() {
        // your token‐loading logic
    }
}
