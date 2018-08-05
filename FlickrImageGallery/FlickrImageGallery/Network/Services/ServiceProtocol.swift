//
//  ServiceProtocol.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

/// Defining structure for Services
public protocol ServiceProtocol {
    var baseUrl: String {get}
    
    init(with url: String)
    
    typealias completionHandler = (Response) -> ()
    func execute(_ request: Request, onCompletion: @escaping completionHandler)
}
