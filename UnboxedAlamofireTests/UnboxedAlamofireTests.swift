//
//  UnboxedAlamofireTests.swift
//  UnboxedAlamofireTests
//
//  Created by Serhii Butenko on 31/7/16.
//  Copyright © 2016 Serhii Butenko. All rights reserved.
//

@testable import UnboxedAlamofire
import XCTest
import Alamofire

class UnboxedAlamofireTests: XCTestCase {
    
    private let timeout: NSTimeInterval = 5
    
    func test_mapObject() {
        let url = "https://dl.dropboxusercontent.com/u/40912339/fixtures/test_object.json"
        let expectation = expectationWithDescription("\(url)")

        Alamofire.request(.GET, url).responseObject { (response: Response<Candy, NSError>) in
            expectation.fulfill()

            let candy = response.result.value
            
            XCTAssertNotNil(candy, "Response shouldn't be nil")
            XCTAssertNil(response.result.error)
            XCTAssertEqual(candy?.name, "KitKat")
            XCTAssertEqual(candy?.sweetnessLevel, 80)
        }

        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "\(error)")
        }
    }

    func test_mapObjectWithKeyPath() {
        let url = "https://dl.dropboxusercontent.com/u/40912339/fixtures/test_object_keypath.json"
        let expectation = expectationWithDescription("\(url)")
        
        Alamofire.request(.GET, url).responseObject(keyPath: "response") { (response: Response<Candy, NSError>) in
            expectation.fulfill()
            
            let candy = response.result.value
            
            XCTAssertNotNil(candy, "Response shouldn't be nil")
            XCTAssertNil(response.result.error)
            XCTAssertEqual(candy?.name, "KitKat")
            XCTAssertEqual(candy?.sweetnessLevel, 80)
        }
        
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    func test_mapObjectWithNestedKeyPath() {
        let url = "https://dl.dropboxusercontent.com/u/40912339/fixtures/test_object_nested_keypath.json"
        let expectation = expectationWithDescription("\(url)")
        
        Alamofire.request(.GET, url).responseObject(keyPath: "response.my") { (response: Response<Candy, NSError>) in
            expectation.fulfill()
            
            let candy = response.result.value
            
            XCTAssertNotNil(candy, "Response shouldn't be nil")
            XCTAssertNil(response.result.error)
            XCTAssertEqual(candy?.name, "KitKat")
            XCTAssertEqual(candy?.sweetnessLevel, 80)
        }
        
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    func test_mapArray() {
        let url = "https://dl.dropboxusercontent.com/u/40912339/fixtures/test_array.json"
        let expectation = expectationWithDescription("\(url)")
        
        Alamofire.request(.GET, url).responseArray { (response: Response<[Candy], NSError>) in
            expectation.fulfill()
            
            let candies = response.result.value
            
            XCTAssertNotNil(candies, "Response shouldn't be nil")
            XCTAssertNil(response.result.error)
            XCTAssertEqual(candies?.count, 4)
        }
        
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    func test_mapArrayWithKeyPath() {
        let url = "https://dl.dropboxusercontent.com/u/40912339/fixtures/test_array_keypath.json"
        let expectation = expectationWithDescription("\(url)")
        
        Alamofire.request(.GET, url).responseArray(keyPath: "wish") { (response: Response<[Candy], NSError>) in
            expectation.fulfill()
            
            let candies = response.result.value
            
            XCTAssertNotNil(candies, "Response shouldn't be nil")
            XCTAssertNil(response.result.error)
            XCTAssertEqual(candies?.count, 4)
        }
        
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "\(error)")
        }
    }
    
    func test_mapArrayWithNestedKeyPath() {
        let url = "https://dl.dropboxusercontent.com/u/40912339/fixtures/test_array_nested_keypath.json"
        let expectation = expectationWithDescription("\(url)")
        
        Alamofire.request(.GET, url).responseArray(keyPath: "response.wish") { (response: Response<[Candy], NSError>) in
            expectation.fulfill()
            
            let candies = response.result.value
            
            XCTAssertNotNil(candies, "Response shouldn't be nil")
            XCTAssertNil(response.result.error)
            XCTAssertEqual(candies?.count, 4)
        }
        
        waitForExpectationsWithTimeout(timeout) { error in
            XCTAssertNil(error, "\(error)")
        }
    }
}
