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
    
    fileprivate let timeout: TimeInterval = 5
    
    func test_mapObject() {
        let url = "https://raw.githubusercontent.com/serejahh/UnboxedAlamofire/890674cdfdcf2424f2c45ff5f4af455ccfaf7617/UnboxedAlamofireTests/fixtures/test_object.json"
        let expectation = self.expectation(description: "\(url)")

        Alamofire.request(url, method: .get).responseObject { (response: DataResponse<Candy>) in
            expectation.fulfill()

            let candy = response.result.value
            
            XCTAssertNotNil(candy, "Response shouldn't be nil")
            XCTAssertNil(response.result.error)
            XCTAssertEqual(candy?.name, "KitKat")
            XCTAssertEqual(candy?.sweetnessLevel, 80)
        }

        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, error!.localizedDescription)
        }
    }

    func test_mapObjectWithKeyPath() {
        let url = "https://raw.githubusercontent.com/serejahh/UnboxedAlamofire/890674cdfdcf2424f2c45ff5f4af455ccfaf7617/UnboxedAlamofireTests/fixtures/test_object_keypath.json"
        let expectation = self.expectation(description: "\(url)")
        
        Alamofire.request(url, method: .get).responseObject(keyPath: "response") { (response: DataResponse<Candy>) in
            expectation.fulfill()
            
            let candy = response.result.value
            
            XCTAssertNotNil(candy, "Response shouldn't be nil")
            XCTAssertNil(response.result.error)
            XCTAssertEqual(candy?.name, "KitKat")
            XCTAssertEqual(candy?.sweetnessLevel, 80)
        }
        
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, error!.localizedDescription)
        }
    }
    
    func test_mapObjectWithKeyPathAtArrayIndex() {
        let url = "https://raw.githubusercontent.com/serejahh/UnboxedAlamofire/890674cdfdcf2424f2c45ff5f4af455ccfaf7617/UnboxedAlamofireTests/fixtures/test_array_keypath.json"
        let expectation = self.expectation(description: "\(url)")
        
        Alamofire.request(url, method: .get).responseObject(keyPath: "wish.0") { (response: DataResponse<Candy>) in
            expectation.fulfill()
            
            let candy = response.result.value
            
            XCTAssertNotNil(candy, "Response shouldn't be nil")
            XCTAssertNil(response.result.error)
            XCTAssertEqual(candy?.name, "KitKat")
            XCTAssertEqual(candy?.sweetnessLevel, 80)
        }
        
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, error!.localizedDescription)
        }
    }
    
    func test_mapObjectWithNestedKeyPath() {
        let url = "https://raw.githubusercontent.com/serejahh/UnboxedAlamofire/890674cdfdcf2424f2c45ff5f4af455ccfaf7617/UnboxedAlamofireTests/fixtures/test_object_nested_keypath.json"
        let expectation = self.expectation(description: "\(url)")
        
        Alamofire.request(url, method: .get).responseObject(keyPath: "response.my") { (response: DataResponse<Candy>) in
            expectation.fulfill()
            
            let candy = response.result.value
            
            XCTAssertNotNil(candy, "Response shouldn't be nil")
            XCTAssertNil(response.result.error)
            XCTAssertEqual(candy?.name, "KitKat")
            XCTAssertEqual(candy?.sweetnessLevel, 80)
        }
        
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, error!.localizedDescription)
        }
    }
    
    func test_mapArray() {
        let url = "https://raw.githubusercontent.com/serejahh/UnboxedAlamofire/890674cdfdcf2424f2c45ff5f4af455ccfaf7617/UnboxedAlamofireTests/fixtures/test_array.json"
        let expectation = self.expectation(description: "\(url)")
        
        Alamofire.request(url, method: .get).responseArray { (response: DataResponse<[Candy]>) in
            expectation.fulfill()
            
            let candies = response.result.value
            
            XCTAssertNotNil(candies, "Response shouldn't be nil")
            XCTAssertNil(response.result.error)
            XCTAssertEqual(candies?.count, 4)
        }
        
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, error!.localizedDescription)
        }
    }
    
    func test_mapArrayWithKeyPath() {
        let url = "https://raw.githubusercontent.com/serejahh/UnboxedAlamofire/890674cdfdcf2424f2c45ff5f4af455ccfaf7617/UnboxedAlamofireTests/fixtures/test_array_keypath.json"
        let expectation = self.expectation(description: "\(url)")
        
        Alamofire.request(url, method: .get).responseArray(keyPath: "wish") { (response: DataResponse<[Candy]>) in
            expectation.fulfill()
            
            let candies = response.result.value
            
            XCTAssertNotNil(candies, "Response shouldn't be nil")
            XCTAssertNil(response.result.error)
            XCTAssertEqual(candies?.count, 4)
        }
        
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, error!.localizedDescription)
        }
    }
    
    func test_mapArrayWithNestedKeyPath() {
        let url = "https://raw.githubusercontent.com/serejahh/UnboxedAlamofire/890674cdfdcf2424f2c45ff5f4af455ccfaf7617/UnboxedAlamofireTests/fixtures/test_array_nested_keypath.json"
        let expectation = self.expectation(description: "\(url)")
        
        Alamofire.request(url, method: .get).responseArray(keyPath: "response.wish") { (response: DataResponse<[Candy]>) in
            expectation.fulfill()
            
            let candies = response.result.value
            
            XCTAssertNotNil(candies, "Response shouldn't be nil")
            XCTAssertNil(response.result.error)
            XCTAssertEqual(candies?.count, 4)
        }
        
        waitForExpectations(timeout: timeout) { error in
            XCTAssertNil(error, error!.localizedDescription)
        }
    }
}
