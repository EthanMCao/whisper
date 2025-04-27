import Foundation
import Combine
import Starscream

class HelloViewModel: ObservableObject {
    @Published var greeting: String = "Hello, Whisper!"
    private var socket: WebSocket?

    func pingServer() {
        // Change this line:
        let url = URL(string: "ws://localhost:8000/ws/ping")!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.delegate = self
        socket?.connect()
    }
}

extension HelloViewModel: WebSocketDelegate {
    // ← notice WebSocketClient here, not WebSocket
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected:
            client.write(string: "ping")
        case .text(let text):
            DispatchQueue.main.async { self.greeting = text }
            client.disconnect()
        case .error(let error):
            print("WebSocket error:", error ?? "unknown")
        default:
            break
        }
    }
}
