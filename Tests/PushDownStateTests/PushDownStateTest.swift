//
//  File.swift
//  
//
//  Created by Nikhil Menon on 2/6/21.
//

import UIKit
import XCTest
@testable import PushDownState

class PushDownStateTests: XCTestCase {
    var button: PushDownButton!
    
    override func setUp() {
        button = PushDownButton()
    }
    
    func testPushDownRoundCorners() {
        XCTAssertTrue(button.pushDownRoundCorners)
    }
    
    override func tearDown() {
        button = nil
    }
}
