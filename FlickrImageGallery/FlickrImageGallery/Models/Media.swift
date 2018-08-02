//
//  Media.swift
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Represents the media (image urls) associated with an `Item`
public struct Media {
    //MARK:- Private Members
    private (set) var urlString: String?
    private (set) var imageExtension: String?
    private (set) var thumbnailUrlString: String?
    
    //MARK:- Constants
    //Taken from https://www.flickr.com/services/api/misc.urls.html
    static let ThumbnailSuffix = "_m"
    static let ImageSuffix = "_h"

    //MARK:- Initializers
    /// Returns a newly initialized `Media` object by splitting the provided url into baseUrl and extension
    /// As per [Flick Url Documentation](https://www.flickr.com/services/api/misc.urls.html), the public feed returns url in the following format:
    /// - __https://url_sizeIdentifier.extension__ where `sizeIdentifier` defines the size of image returned (some possible values are m, h, b etc.
    /// - What We do here is divide the url into imageExtension (jpg etc.) and a generic url (url without `_sizeIndentifier` as well as without extension. This way, I can generate url for any image on the fly by appending the sizeIndentifier
    /// - The public feed normally returns the media (_m) url, but We generating the generic one (without _m)
    /// - Parameters:
    ///   - item: `SwiftyJSON`'s JSON object representing the item
    
    public init(with item: JSON) {
        guard let sizeIdentifier = Array(item["media"].dictionaryValue.keys).first else {
            return
        }
        
        guard let mediaUrlString = item["media"][sizeIdentifier].string else {
            return
        }
        
        guard let url = URL(string: mediaUrlString) else {
            return
        }
        
        imageExtension = url.pathExtension
        urlString = mediaUrlString.replacingOccurrences(of: "_\(sizeIdentifier)", with: "").replacingOccurrences(of: ".\(imageExtension!)", with: "")
        thumbnailUrlString = generateThumbnailUrlString()
    }
    
    ///MARK:- Private Method
    private func generateThumbnailUrlString() -> String? {
        guard let mediaUrlString = urlString else {
            return nil
        }

        guard let imageExtension = imageExtension else {
            return nil
        }

        
        return mediaUrlString.appending(Media.ThumbnailSuffix).appending(".").appending(imageExtension)
    }

    ///MARK:- Public Properties
    /// Provides the thumbnail url
    public var thumbnailUrl: URL? {
        guard let thumbnailUrlString = self.thumbnailUrlString else {
            return nil
        }
        
        return URL(string: thumbnailUrlString)
    }
    
    /// Provides the full size image url
    public var imageUrl: URL? {
        guard let imageUrlString = thumbnailUrlString?.replacingOccurrences(of: Media.ThumbnailSuffix, with: Media.ImageSuffix) else {
            return nil
        }
        
        return URL(string: imageUrlString)
    }

}
