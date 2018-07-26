//
//  PublicServiceTests.swift
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//
import XCTest

@testable import FlickrImageGallery
@testable import SwiftyJSON

/// Testing PublicService. Support for calling the API as well as stubbing (mocked response) the API response
class PublicServiceTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    /// Testing Public Photos Task with Mocked response
    func testMockedPublicPhotosTask() {
        var data: String?
        if let filePath = Bundle(for: type(of: self)).path(forResource: "public_service_response", ofType: "json") {
            do {
                data = try String(contentsOfFile: filePath)
            } catch(let error) {
                XCTFail(error.localizedDescription)
                return
            }
        }
        
        let service = MockedService(data!)
        testPublicPhotosTask(with: service) { list in
            //Additional testing
            XCTAssertTrue(list.items.first?.title == "Test post 1")
        }
    }
    
    /// Testing PublicPhotosTask with real network call
    func testPublicPhotosTask() {
        let service = FeedsService()
        testPublicPhotosTask(with: service)
    }

    
    /// Generic function for testing public photos task
    func testPublicPhotosTask(with service: Service, onSuccess successCallback: (((List) -> Void)?) = nil) {
        let testExpectation = expectation(description: "Expecting Public photos feed")
        
        let task = PublicPhotosTask(with: nil, sortBy: .none)
        task.execute(in: service, onSuccess: { list in
            testExpectation.fulfill()
            XCTAssertTrue(list.items.count > 0)
            
            successCallback?(list)
        }) { (error, tags) in
            testExpectation.fulfill()
            XCTFail("\(error) for tags (\(String(describing: tags))")
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error :\(error)")
            }
        }
        
    }
}

