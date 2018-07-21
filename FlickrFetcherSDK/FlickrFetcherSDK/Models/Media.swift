//
//  Media.swift
//  FlickrFetcherSDK
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

/// Represents the media (image urls) associated with an `Item`
public class Media {
    //MARK:- Private Members
    private var _urlString: String
    private var _imageExtension: String

    //MARK:- Static Constants
    //Taken from https://www.flickr.com/services/api/misc.urls.html
    static let thumbnailSuffix = "_m"
    static let imageSuffix = "_h"

    //MARK:- Initializers
    /// Returns a newly initialized `Media` object by splitting the provided url into baseUrl and extension
    /// As per [Flick Url Documentation](https://www.flickr.com/services/api/misc.urls.html), the public feed returns url in the following format:
    /// - __https://url_sizeIdentifier.extension__ where `sizeIdentifier` defines the size of image returned (some possible values are m, h, b etc.
    /// - What We do here is divide the url into imageExtension (jpg etc.) and a generic url (url without `_sizeIndentifier` as well as without extension. This way, I can generate url for any image on the fly by appending the sizeIndentifier
    /// - The public feed normally returns the media (_m) url, but We generating the generic one (without _m)
    /// - Parameters:
    ///   - urlString: The Flickr image `url` with `sizeIndentifier` and extension.
    ///   - sizeIdentifier: This identifies the size of the image. m, h, b etc. are some possible values. Please visit [Flick Url Documentation](https://www.flickr.com/services/api/misc.urls.html) for all the sizeIdentifiers
    public init(with urlString: String, _ sizeIdentifier: String) {
        if let url = URL(string: urlString) {
            _imageExtension = url.pathExtension
            
            //removing size specific data such as _m and also removing extension
            _urlString = urlString.replacingOccurrences(of: "_\(sizeIdentifier)", with: "").replacingOccurrences(of: ".\(_imageExtension)", with: "")
        } else {
            _imageExtension = ""
            _urlString = ""
        }        
    }
    
    //MARK:- Public Properties
    /// Provides the thumbnail url
    public var thumbnailUrl: URL? {
        let urlString = "\(_urlString)\(Media.thumbnailSuffix).\(_imageExtension)"
        return URL(string: urlString)
    }

    /// Provides the full size image url
    public var imageUrl: URL? {
        let urlString = "\(_urlString)\(Media.imageSuffix).\(_imageExtension)"
        return URL(string: urlString)
    }
    
}
