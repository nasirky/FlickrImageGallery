//
//  MockedService.swift
//  NetworkLayer
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import UIKit

/// MockedService that takes the output data (response) as String and returns it as Response object (by passing the network call in the service)
/// Another way is to conform to ServiceProtocol (instead of subclassing Service).
class MockedService: Service {
    /// Stores the mocked response
    private var response: String

    // utilizing the same initializer that ServiceProtcol uses for initializing baseUrl (just changing the variable name for easy understanding
    required init(with response: String) {
        self.response = response
        super.init(with: "")  //Url not needed for MockedService
    }
    
    override func execute(_ request: Request, onCompletion: @escaping (Response) -> ()) {
        onCompletion(Response(with: response.data(using: .utf8), nil, request.responseModel))
    }
}
