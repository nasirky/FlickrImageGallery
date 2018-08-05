//
//  Request.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

public protocol Request {
    var path: String {get}
    var method: HTTPMethod {get}
    var parameters: [String: Any]? {get}
    var headers: [String: Any]? {get}
    var responseParser: ResponseParser {get}
    
    func urlRequest(in service: ServiceProtocol) -> URLRequest
}

extension Request {
    func urlRequest(in service: ServiceProtocol) -> URLRequest {
        let baseUrl = service.baseUrl.appending(path) as String
        var urlRequest = URLRequest(url: URL(string: baseUrl)!)
        switch self.method {
        case .get:
            if var urlComponents = URLComponents(string: baseUrl) {
                urlComponents.queryItems = getQueryItems(for: baseUrl, parameters)
                urlRequest.url = urlComponents.url
            }
            
        default:
            break
        }

        self.headers?.forEach { (key,value) in
            urlRequest.addValue(value as! String, forHTTPHeaderField: key)
        }

        urlRequest.httpMethod = self.method.rawValue
        
        return urlRequest
    }
    
    func getQueryItems(for url: String,_ parameters: [String: Any]?) -> [URLQueryItem] {
        // assuming all parameters to be string
        guard let parameters = parameters as? [String:String] else {
            return [URLQueryItem]()
        }
        
        let queryItems = parameters.map { param in
            return URLQueryItem(name: param.key, value: param.value)
        }
        
        return queryItems
    }
}
