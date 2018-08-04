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
    case error(_: Error)
    case data(_: Data)
    
    init(with data: Data?, _ error: Error?) {
        guard error == nil else {
            self = .error(error!)
            return
        }
        
        guard let data = data else {
            self = .error(NSError(domain: "", code: 404, userInfo: nil))
            return
        }
        
        self = .data(data)
    }
}
