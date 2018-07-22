//
//  PublicServiceStub.swift
//  FlickrFetcherSDKTests
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
import OHHTTPStubs

@testable import FlickrFetcherSDK

class PublicServiceStubs {
    
    /// Sets up and loads the Stub. The main idea is to listen for the path and then provide a json response (of the same structure as the real response, preferrably downloaded from the same API at some point). At the moment, since we have one function, so we are defining only 1 stub.
    /// To be called in `setUp` method of the Test
    static func loadStubs() {
        let path = PublicServiceUrls.publicPhotos.replacingOccurrences(of: Urls.feeds, with: "")
        stub(condition: pathEndsWith(path)) { request in
            let stubPath = OHPathForFile("public_service_response.json", PublicServiceStubs.self)
            
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        
        OHHTTPStubs.setEnabled(true)
    }
    
    /// Unloads the Stub.
    /// To be called in `tearDown` method of the Test
    static func unloadStubs() {
        OHHTTPStubs.setEnabled(false)
    }
}
