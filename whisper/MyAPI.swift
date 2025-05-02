//
//  MyAPI.swift
//  whisper
//
//  Created by Ethan Cao on 4/29/25.
//
//
//  MyAPI.swift
//  whisper
//
//  Created by Ethan Cao on 4/29/25.
//
//
//  MyAPI.swift
//  whisper
//
//  Created by Ethan Cao on 4/29/25.
//

import Foundation

// MARK: – Message DTOs

/// What we decode when fetching or sending messages
struct MessageRead: Codable, Identifiable {
    let id: Int
    let sender: String
    let recipient: String
    let content: String
    let timestamp: Date
}

/// What we encode when sending a new message
struct MessageCreate: Codable {
    let sender: String
    let recipient: String
    let content: String
}

// MARK: – API Errors

enum APIError: Error {
    case badURL
    case decoding
    case server(String)
}

// MARK: – Unified API Client

struct MyAPI {
    /// Use `localhost` so iOS ATS permits plain‐HTTP to your FastAPI server
    static let baseURL = URL(string: "http://localhost:8000")!

    /// ISO8601 formatter that can parse fractional seconds
    private static let isoWithFrac: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()
    /// ISO8601 formatter without fractional seconds
    private static let isoWithoutFrac = ISO8601DateFormatter()

    /// A JSONDecoder configured to try both formats
    private static func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            if let d = isoWithFrac.date(from: dateStr) {
                return d
            }
            if let d = isoWithoutFrac.date(from: dateStr) {
                return d
            }
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot parse date string: \(dateStr)"
            )
        }
        return decoder
    }

    /// Log in and get back a JWT token
    static func login(
        username: String,
        password: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let url = baseURL.appendingPathComponent("login")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["username": username, "password": password]
        req.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: req) { data, resp, err in
            if let err = err {
                print("⚠️ login network error:", err)
                return completion(.failure(err))
            }
            guard
                let http = resp as? HTTPURLResponse,
                let data = data
            else {
                print("⚠️ login no response or no data")
                return completion(.failure(APIError.server("No response or data")))
            }

            let bodyText = String(data: data, encoding: .utf8) ?? "<binary>"
            print("ℹ️ login → HTTP", http.statusCode, "body:", bodyText)

            if http.statusCode == 200 {
                struct TokenResponse: Codable {
                    let access_token: String
                    let token_type: String
                }
                do {
                    let tr = try JSONDecoder().decode(TokenResponse.self, from: data)
                    completion(.success(tr.access_token))
                } catch {
                    print("⚠️ login decode error:", error)
                    completion(.failure(APIError.decoding))
                }
            } else {
                if
                    let errObj = try? JSONDecoder().decode([String:String].self, from: data),
                    let msg = errObj["detail"]
                {
                    print("⚠️ login server detail:", msg)
                    completion(.failure(APIError.server(msg)))
                } else {
                    let fallback = HTTPURLResponse.localizedString(forStatusCode: http.statusCode)
                    print("⚠️ login server fallback:", fallback)
                    completion(.failure(APIError.server(fallback)))
                }
            }
        }
        .resume()
    }

    /// Fetch all messages for a given user
    static func fetchMessages(
        for username: String,
        token: String,
        completion: @escaping (Result<[MessageRead], Error>) -> Void
    ) {
        let url = baseURL.appendingPathComponent("messages/\(username)")
        var req = URLRequest(url: url)
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: req) { data, resp, err in
            if let err = err {
                print("⚠️ fetchMessages network error:", err)
                return completion(.failure(err))
            }
            guard
                let http = resp as? HTTPURLResponse,
                let data = data
            else {
                print("⚠️ fetchMessages no response or no data")
                return completion(.failure(APIError.server("No data")))
            }

            let bodyText = String(data: data, encoding: .utf8) ?? "<binary>"
            print("ℹ️ fetchMessages → HTTP", http.statusCode, "body:", bodyText)

            do {
                let decoder = makeDecoder()
                let msgs = try decoder.decode([MessageRead].self, from: data)
                completion(.success(msgs))
            } catch {
                print("⚠️ fetchMessages decode error:", error)
                completion(.failure(APIError.decoding))
            }
        }
        .resume()
    }

    /// Send a new message
    static func sendMessage(
        _ message: MessageCreate,
        token: String,
        completion: @escaping (Result<MessageRead, Error>) -> Void
    ) {
        let url = baseURL.appendingPathComponent("messages/send")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.httpBody = try? JSONEncoder().encode(message)

        URLSession.shared.dataTask(with: req) { data, resp, err in
            if let err = err {
                print("⚠️ sendMessage network error:", err)
                return completion(.failure(err))
            }
            guard
                let http = resp as? HTTPURLResponse,
                let data = data
            else {
                print("⚠️ sendMessage no response or no data")
                return completion(.failure(APIError.server("No data")))
            }

            let bodyText = String(data: data, encoding: .utf8) ?? "<binary>"
            print("ℹ️ sendMessage → HTTP", http.statusCode, "body:", bodyText)

            do {
                let decoder = makeDecoder()
                let msg = try decoder.decode(MessageRead.self, from: data)
                completion(.success(msg))
            } catch {
                print("⚠️ sendMessage decode error:", error)
                completion(.failure(APIError.decoding))
            }
        }
        .resume()
    }
}
