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
  var apiTestManage: APIManagerClass = APIManagerClass()

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

  func testJSONMapping() throws {
      let bundle = Bundle(for: type(of: self))

      guard let url = bundle.url(forResource: "facts", withExtension: "json") else {
          XCTFail("Missing file: User.json")
          return
      }

      let data = try Data(contentsOf: url)
      let jsonString = String(decoding: data, as: UTF8.self)
      let jsonData = Data(jsonString.utf8)
      let jsonDictionary = apiTestManage.convertToDictionary(text: jsonData)

    let jsonSerialize = try JSONSerialization.data(withJSONObject: jsonDictionary as Any, options: .prettyPrinted)
    let jsonDecoder = JSONDecoder()
    let responseModel = try jsonDecoder.decode(ListResponse.self, from: jsonSerialize)
    //debugPrint("Finished in unit test!!!",responseModel as Any)
    let responseSubModel = responseModel.rows

    
    XCTAssertEqual(responseModel.title, "About Canada")
    XCTAssertEqual(responseSubModel.first?.title, "Beavers")
    
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

}
