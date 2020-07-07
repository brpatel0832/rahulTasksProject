//
//  TestListVC.swift
//  rahulIosTaskTests
//
//  Created by Rahul Patel on 07/07/20.
//  Copyright © 2020 Rahul Patel. All rights reserved.
//

import XCTest

class TestListVC: XCTestCase {

  var controllerUnderTest: ListViewController = ListViewController()

  override func setUp(){
    controllerUnderTest.loadViewIfNeeded()
    self.controllerUnderTest.viewDidLoad()
    //XCTAssertNotNil(controllerUnderTest.ListTableView,"Controller should have a tableview")
  }
  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
      super.tearDown()
  }
    func testHasATableView() {
          XCTAssertNotNil(controllerUnderTest.ListTableView)
      }

      func testTableViewHasDelegate() {
          XCTAssertNotNil(controllerUnderTest.ListTableView.delegate)
      }

      func testTableViewConfromsToTableViewDelegateProtocol() {
          XCTAssertTrue(controllerUnderTest.conforms(to: UITableViewDelegate.self))

      }

      func testTableViewHasDataSource() {
          XCTAssertNotNil(controllerUnderTest.ListTableView.dataSource)
      }

      func testTableViewConformsToTableViewDataSourceProtocol() {
          XCTAssertTrue(controllerUnderTest.conforms(to: UITableViewDataSource.self))
          XCTAssertTrue(controllerUnderTest.responds(to: #selector(controllerUnderTest.tableView(_:numberOfRowsInSection:))))
          XCTAssertTrue(controllerUnderTest.responds(to: #selector(controllerUnderTest.tableView(_:cellForRowAt:))))
      }


      func testTableViewCellHasReuseIdentifier() {
          // giving data value
          let listData = [ListResponsesub(title: "onecup", description: "onecup coffe", imageHref: "")]
          controllerUnderTest.listData = listData

          let indexPath = IndexPath(row: 0, section: 0)

          let cell = controllerUnderTest.tableView(controllerUnderTest.ListTableView, cellForRowAt: indexPath) as? ListTableViewCell

          let actualReuseIdentifer = cell?.reuseIdentifier
          let expectedReuseIdentifier = "ListTableViewCell"
          XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
      }

      func testValueCell() {

          // giving data value
          let listData = [ListResponsesub(title: "onecup", description: "onecup coffe", imageHref: "")]
          controllerUnderTest.listData = listData

          let indexPath = IndexPath(row: 0, section: 0)

          // expected CurrencyCell class
        guard let cell = controllerUnderTest.tableView(controllerUnderTest.ListTableView, cellForRowAt: indexPath) as? ListTableViewCell else {
              XCTAssert(false, "Expected CurrencyCell class")
              return
          }
          XCTAssertEqual(cell.postData?.title!, "onecup")
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
