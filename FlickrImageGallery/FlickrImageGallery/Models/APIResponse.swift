//
//  PublicStream.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
public struct APIResponse: Codable {
    let items: [Item]
    
    // For Non-Item related replies (might be success or failure)
    let status: String?
    let message: String?
    
    private enum CodingKeys: String, CodingKey {
        case items
        case status = "stat"
        case message
    }
    
    // Implementing own decoder to provide default values for missing keys
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decodeIfPresent([Item].self, forKey: .items) ?? [Item]()
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? nil
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? nil
    }
}
