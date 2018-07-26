//
//  PublicPhotosTask.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Represents the Public Photos Fetching Task. It fetches the public stream from Flickr and returns a List object
public class PublicPhotosTask: TaskProtocol {
    typealias T = List
    
    var tags: [String]?
    var sortOrder: SortOrder
    var ttl: Int

    public init(with tags: [String]?, sortBy sortOrder: SortOrder, expiresIn ttl: Int = 0) {
        self.tags = tags
        self.sortOrder = sortOrder
        self.ttl = ttl
    }
    
    var request: Request {
        return PublicStreamRequest.fetchPublicPhotos(tags: tags)
    }
    
    func execute(in service: ServiceProtocol, onSuccess success: ((List) -> Void)?, onFailure failure: TaskProtocol.failureClosure) {
        service.execute(self.request) { response in
            switch response {
            case .json(let json):
                let items = json["items"].arrayValue.map({ itemJSON in
                    return Item(with: itemJSON)
                })
                let list = List(withItems: items, withTags: self.tags, sortBy: self.sortOrder, expiresIn: self.ttl)
                success?(list)
            case .error(let error):
                failure?(error)
            }
        }
    }
}
