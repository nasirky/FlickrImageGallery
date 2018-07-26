//
//  Service.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
import Alamofire

/// The only layer making the network calls. It takes request object and returns a response object (enum)
/// Error handling and conversion to JSON is hapenning inside Response
class Service: ServiceProtocol {
    public var baseUrl: String

    required init(with url: String) {
        self.baseUrl = url
    }
    
    func execute(_ request: Request, onCompletion: @escaping (Response) -> ()) {
        let operation = Alamofire.request(request.urlRequest(in: self))
        operation.responseData { response in
            let response = Response(with: response.data, response.error)
            onCompletion(response)
        }
    }
}
