//
//  AlertError.swift
//  whisper
//
//  Created by Ethan Cao on 4/29/25.
//

// AlertError.swift
import Foundation

/// Wraps a String so you can drive SwiftUI `.alert(item:)`
struct AlertError: Identifiable {
  let id = UUID()
  let message: String
}
