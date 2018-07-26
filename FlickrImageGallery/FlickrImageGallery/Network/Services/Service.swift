//
//  Service.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
import Alamofire

class Service: ServiceProtocol {
    public var baseUrl: String

    init(with url: String) {
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
