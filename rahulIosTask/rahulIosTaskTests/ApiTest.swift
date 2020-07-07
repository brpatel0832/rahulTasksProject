//
//  ApiTest.swift
//  rahulIosTaskTests
//
//  Created by Rahul Patel on 07/07/20.
//  Copyright © 2020 Rahul Patel. All rights reserved.
//

import XCTest
@testable import Alamofire

class ApiTest: XCTestCase {

  var apiTest: ListViewController = ListViewController()

  func callApiResponse(){
    let e = expectation(description: "Alamofire")
    
    apiTest.getPostData { (isFinished: Bool) in
      if isFinished {
        debugPrint("Finished in unit test!!!")
        let actual = isFinished
        let expectedString = true
        XCTAssertEqual(actual, expectedString)

      }
      e.fulfill()
    }
   waitForExpectations(timeout: 5.0, handler: nil)

  }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
