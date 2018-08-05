//
//  Media.swift
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

/// Represents the media (image urls) associated with an `Item`
public struct Media: Codable {
    //MARK:- Private Members
    private let urlString: String
  
    private enum CodingKeys: String, CodingKey {
        case urlString = "m"
    }
    
    //MARK:- Constants
    //Taken from https://www.flickr.com/services/api/misc.urls.html
    static let ThumbnailSuffix = "_m"
    static let ImageSuffix = "_h"
    
    ///MARK:- Public Properties
    /// Provides the thumbnail url
    public var thumbnailUrl: URL? {
        return URL(string: urlString)
    }
    
    /// Provides the full size image url
    public var imageUrl: URL? {
        return URL(string: urlString.replacingOccurrences(of: Media.ThumbnailSuffix, with: Media.ImageSuffix))
    }

}
