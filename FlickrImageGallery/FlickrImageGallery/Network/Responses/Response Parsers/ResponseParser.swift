//
//  ResponseParser.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
/// Protocol that identifies which variables and methods that a ResponseParser needs to conform to.
/// We are using APIResponse.Type as the responseType as it is the root level struct to handle all responses from the API
public protocol ResponseParser {
    var responseType: APIResponse.Type {get}
    
    init(with responseType: APIResponse.Type)

    func parse(_ data: Data) throws -> (APIResponse)
}
