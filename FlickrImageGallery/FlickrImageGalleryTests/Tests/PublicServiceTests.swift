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
    var helper: Helper?
    
    override func setUp() {
        super.setUp()
        helper = Helper()
    }
    
    override func tearDown() {
        super.tearDown()
        
        helper = nil
    }

    /// Testing Public Photos Task with Mocked response
    func testMockedPublicPhotosTask() {
        guard let fileContents = helper?.fetchFileContent(from: "public_photo_stream_response", withExtension: "json") else {
            XCTFail("Error reading file")
            return
        }
        
        let service = MockedService(with: fileContents)
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
        
        waitForExpectations(timeout: 15) { (error) in
            if let error = error {
                XCTFail("Error :\(error)")
            }
        }
        
    }
}

