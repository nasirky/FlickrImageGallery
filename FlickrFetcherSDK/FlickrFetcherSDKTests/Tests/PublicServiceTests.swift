//
//  PublicServiceTests.swift
//  FlickrFetcherSDKTests
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//
import XCTest

@testable import FlickrFetcherSDK
@testable import SwiftyJSON

/// Testing PublicService. Support for calling the API as well as stubbing (mocked response) the API response
class PublicServiceTests: XCTestCase {
    override func setUp() {
        super.setUp()

        // Setting up the stubs (mocked response) for Public Service. The API response is being stubbed with a similar response (downloaded from the same API) for testing purposes.
        //TODO: comment the line below for real API requests
        PublicServiceStubs.loadStubs()
    }
    
    override func tearDown() {
        // Unloading the stubs
        //TODO: comment the line below for real API requests
        PublicServiceStubs.unloadStubs()

        super.tearDown()
    }

    /// Testing the FetchPublicPhotos service. There are two ways to test:
    /// 1. Using real Network calls
    /// 2. Without using Network calls (stubbing/mocking the response) -> active by default in this test
    /// To avoid network uncertainity and to test that the service performs the functionality it is intended to, stubbing/mocking is used. Instead of the original network call, the response is taken from the developer specified file.
    /// To use real network calls, plesae comment `PublicServiceStubs.loadStubs()` from `setUp()` and `PublicServiceStubs.unloadStubs()` from `tearDown()`
    func testFetchPublicPhotos() {
        let testExpectation = expectation(description: "Expecting Public Photo feed")
        PublicService.sharedInstance.fetchPublicPhotos(with: nil, onSuccess: { (items, tags) in
            testExpectation.fulfill()
            
            XCTAssertNil(tags)
            
            //TODO: Uncomment the line below to verify that the stubbed/mocked response is being used (do not use it for real api requests, other the test will fail)
//            XCTAssertEqual(items.first?.title, "Test post 1")

            let list = List(with: items)
            let listItems = list.items
            
            // Testing if List is correctly formed. For more tests (on List and other models), please see `ModelTests`
            XCTAssertEqual(listItems.count, items.count)
            XCTAssertEqual(list.ttl, 0)

            XCTAssertEqual(listItems.first,items.first)
            XCTAssertEqual(listItems.last,items.last)
            
            //Generating randomIndex from the array. At the moment, it can also pick the first and last item
            let randomIndex = Int(arc4random_uniform(UInt32(items.count)))
            XCTAssertEqual(listItems[randomIndex], items[randomIndex])
        }, onFailure: { (reason, tags) in
            testExpectation.fulfill()
            
            XCTFail(reason)
        })
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error :\(error)")
            }
        }
    }
}

