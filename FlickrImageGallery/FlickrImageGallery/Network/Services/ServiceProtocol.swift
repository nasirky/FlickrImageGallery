//
//  ServiceProtocol.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

public protocol ServiceProtocol {
    var baseUrl: String {get}
    
    typealias completionHandler = (Response) -> ()
    func execute(_ request: Request, onCompletion: @escaping completionHandler)
}
