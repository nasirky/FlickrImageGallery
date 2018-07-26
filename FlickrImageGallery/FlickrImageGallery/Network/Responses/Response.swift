//
//  Response.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir on 7/26/18.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

/// Represents the response returned by the Service to the Task (Service is the entity executing the network calls and task represents one network call).
public enum Response {
    case json(_: JSON)
    case error(_: String)
    
    init(with data: Data?, _ error: Error?) {
        guard error == nil else {
            self = .error(error!.localizedDescription)
            return
        }
        
        guard let data = data else {
            self = .error("No Data returned")
            return
        }
        
        self = .json(JSON(data))
    }
}
