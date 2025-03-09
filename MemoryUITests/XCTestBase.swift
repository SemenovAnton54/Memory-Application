//
//  XCTestBase.swift
//  Memory
//
//  Created by Anton Semenov on 09.03.2025.
//

import XCTest
import Foundation

class SCTestBase: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["UITests"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }
}
