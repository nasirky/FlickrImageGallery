//
//  Service.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

/// The only layer making the network calls. It takes request object and returns a response object (enum)
/// Error handling and conversion to JSON is hapenning inside Response
class Service: ServiceProtocol {
    var baseUrl: String
    var defaultSession: URLSession

    required init(with url: String) {
        self.baseUrl = url
        defaultSession = URLSession.init(configuration: .default)
    }
    
    func execute(_ request: Request, onCompletion: @escaping (Response) -> ()) {
        let dataTask = defaultSession.dataTask(with: request.urlRequest(in: self)) { data,urlResponse,error in
            let response = Response(with: data, error, request.responseModel)
            DispatchQueue.main.async {
                onCompletion(response)
            }
        }
        
        dataTask.resume()
    }
}
