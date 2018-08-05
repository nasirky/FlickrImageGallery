//
//  Urls.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

/// Represents the Base Urls for different flickr feeds and services. It can be further extended when needed.
struct Urls {
    struct FlickrApi {
        /// The base url of Flickr API
        static let base = "https://api.flickr.com/"
        /// The url for Services endpoint
        static let services = base.appending("services/")
        /// The url for feeds endpoint
        static let feeds = services.appending("feeds/")
        
        struct Public {
            /// The url for accessing Flickr's public photos feed.
            static let photos = "photos_public.gne"
        }
    }
 }
