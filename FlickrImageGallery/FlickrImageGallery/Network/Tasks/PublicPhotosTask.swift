//
//  PublicPhotosTask.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

/// Represents the Public Photos Fetching Task. It fetches the public stream from Flickr and returns a List object
public class PublicPhotosTask: TaskProtocol {
    typealias T = List
    
    var tags: [String]?

    public init(with tags: [String]? = nil) {
        self.tags = tags
    }
    
    var request: Request {
        return PublicStreamRequest.fetchPublicPhotos(tags: tags)
    }
    
    func execute(in service: ServiceProtocol, onSuccess success: ((List) -> Void)?, onFailure failure: TaskProtocol.failureClosure) {
        service.execute(self.request) { response in
            switch response {
            case .response(let apiResponse):
                let list = List(withItems: apiResponse.items)
                success?(list)
            case .string(let string):
                failure?(string)
            case .error(let error):
                failure?(error)
            }
        }
    }
}
