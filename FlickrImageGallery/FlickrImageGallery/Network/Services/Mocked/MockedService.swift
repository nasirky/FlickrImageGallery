//
//  MockedService.swift
//  NetworkLayer
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import UIKit

/// MockedService that takes the output data (response) as String and returns it as Response object (by passing the network call in the service)
class MockedService: Service {
    var response: String
    
    public init(_ response: String) {
        self.response = response
        super.init(with: "")
    }
    
    override func execute(_ request: Request, onCompletion: @escaping (Response) -> ()) {
        onCompletion(Response(with: response.data(using: .utf8), nil))
    }
}
