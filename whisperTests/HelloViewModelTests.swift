//
//  HelloViewModelTests.swift
//  whisperTests
//
//  Created by Ethan Cao on 4/25/25.
//

import XCTest
@testable import whisper

final class HelloViewModelTests: XCTestCase {
    func testDefaultGreeting() {
        let vm = HelloViewModel()
        XCTAssertEqual(vm.greeting, "Hello, Whisper!")
    }
}

