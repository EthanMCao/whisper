//
//  ContentView.swift
//  whisper
//
//  Created by Ethan Cao on 4/25/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HelloViewModel()

    var body: some View {
        VStack {
            Text(viewModel.greeting)
                .font(.largeTitle)
                .padding()

            Button("Ping Server") {
                viewModel.pingServer()
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
