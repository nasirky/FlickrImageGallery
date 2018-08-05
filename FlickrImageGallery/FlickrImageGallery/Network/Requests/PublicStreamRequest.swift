//
//  PhotoRequest.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

/// Specialized Request enum/object for Public Stream specific requests such as fetch public photos etc. Here we define all the components for the public stream request (Adding new request would require adding a new case under Request and then under every subcomponent (such as path, method etc.)
enum PublicStreamRequest: Request {
    
    case fetchPublicPhotos(tags: [String]?)
    
    public var path: String {
        switch self {
        case .fetchPublicPhotos:
            return Urls.FlickrApi.Public.photos
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .fetchPublicPhotos:
            return .get
        }
    }

    public var parameters: [String : Any]? {
        switch self {
        case .fetchPublicPhotos(let tags):
            var params = [String:Any]()
            
            if responseParser is JSONResponseParser {
                ["format" : "json", "nojsoncallback" : "1"].forEach { (key,value) in
                    params[key] = value
                }
            }

            guard let tags = tags else { return params }

            ["tags": tags.joined(separator: ","), "tagmode" : "any"].forEach { (key, value) in
                params[key] = value
            }
            
            return params
        }
    }

    var responseParser: ResponseParser {
        //APIResponse.self is the default responseType for JSONResponseParser()
        return JSONResponseParser()
    }


    // Public stream requests don't require headers so we are returning nil
    public var headers: [String : Any]? {
        switch self {
        default:
            return nil
        }
    }
}
