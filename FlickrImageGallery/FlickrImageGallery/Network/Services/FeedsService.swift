//
//  FeedsService.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

/// Service Representing the Feeds (FlickApi/services/feeds)
class FeedsService: Service {
    public init() {
        super.init(with: Urls.FlickrApi.feeds)
    }
}
