//
//  FeedsService.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
class FeedsService: Service {
    public init() {
        super.init(with: Urls.FlickrApi.feeds)
    }
}
