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
        var fileContents: String?
        guard let filePath = Bundle(for: type(of: self)).path(forResource: "public_service_response", ofType: "json") else {
            XCTFail("Unable to open file")
            return
        }

        do {
            fileContents = try String(contentsOfFile: filePath)
        } catch(let error) {
            XCTFail(error.localizedDescription)
            return
        }
        
        let service = MockedService(with: fileContents!)
        testPublicPhotosTask(with: service) { list in
            //Additional testing
            XCTAssertTrue(list.items.first?.title == "Test post 1")
        }
    }
    
    /// Testing PublicPhotosTask with real network call
    func testPublicPhotosTask() {
        let feedsService = Service(with: Urls.FlickrApi.feeds)
        testPublicPhotosTask(with: feedsService)
    }

    
    /// Generic function for testing public photos task
    func testPublicPhotosTask(with service: Service, onSuccess successCallback: (((List) -> Void)?) = nil) {
        let testExpectation = expectation(description: "Expecting Public photos feed")
        
        let task = PublicPhotosTask(with: nil)
        task.execute(in: service, onSuccess: { list in
            testExpectation.fulfill()
            XCTAssertTrue(list.items.count > 0)
            
            successCallback?(list)
        }) { (error) in
            testExpectation.fulfill()
            XCTFail("Error : \(error.localizedDescription)")
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error :\(error)")
            }
        }
        
    }
}

