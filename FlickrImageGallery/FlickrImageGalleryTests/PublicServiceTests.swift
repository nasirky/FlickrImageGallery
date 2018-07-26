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

    /// Testing the FetchPublicPhotos service.
    func testFetchPublicPhotos() {
        let testExpectation = expectation(description: "Expecting Public Photo feed")

        let service = FeedsService()
        PublicPhotosTask.init(with: nil, sortBy: .none).execute(in: service, onSuccess: { list in
            testExpectation.fulfill()
            
            XCTAssertNil(list.tags)
            guard list.items.count > 0 else {
                XCTFail("No Items retrieved")
                return
            }
        }) { (errorString, tags) in
            testExpectation.fulfill()
            
            XCTFail(errorString)
        }

        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error :\(error)")
            }
        }
    }
}

