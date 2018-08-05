//
//  Response.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir on 7/26/18.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
import UIKit

/// Represents the response returned by the Service to the Task (Service is the entity executing the network calls and task represents one network call). Error handling and JSON parsing are performed here
public enum Response {
    case error(_: String)
    case response(_: APIResponse)
    case string(_: String)
    
    init(with data: Data?, _ error: Error?, parsedBy parser: ResponseParser) {
        if let error = error {
            self = .error(error.localizedDescription)
            return
        }
        
        guard let data = data else {
            self = .error("No Data received from the server")
            return
        }
        do {
            let string = String.init(data: data, encoding: .utf8)
            let response = try parser.parse(data)
            if let status = response.status, status == Constants.API.Response.Failure {
                self = .string(response.message ?? status)
                return
            }
            self = .response(response)
        } catch (let error) {
            self = .error(error.localizedDescription)
        }
    }
}
