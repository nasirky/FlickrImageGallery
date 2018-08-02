//
//  FlickrItem.swift
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Represents the item returned by Flickr API.
public struct Item {
    //MARK:- Private Members
    private (set) var title: String!
    private (set) var media: Media!
    private (set) var description: String!
    private (set) var dateTaken: Date?
    private (set) var datePublished: Date?
    private (set) var tags: [String]?

    //MARK:- Initializers
    /// Returns a newly initialized `Item` object with values fetched from the provided JSON Object.
    /// - Parameters:
    ///   - item: `SwiftyJSON`'s JSON object representing the item
    init(with item: JSON) {
        title = item["title"].stringValue
        media = Media(with: item)
        description = item["description"].stringValue
        
        dateTaken = Date.from(string: item["date_taken"].stringValue)
        datePublished = Date.from(string: item["published"].stringValue, withFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'")
        if item["tags"].stringValue.count > 0 {
            tags = item["tags"].stringValue.components(separatedBy: " ")
        }
    }
    
    // Used for Unit Testing
    init(with item: Item) {
        self.init(item.title, item.media, item.description, item.dateTaken, item.datePublished, item.tags)
     }
    
    init(with item: Item, publishedOn datePublished: String) {
        let date = Date.from(string: datePublished, withFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'")
        self.init(item.title, item.media, item.description, item.dateTaken, date, item.tags)
    }
    
    init(with item: Item, forTags: [String]?) {
        self.init(item.title, item.media, item.description, item.dateTaken, item.datePublished, item.tags)
    }
 
    /// Returns a newly initialized `Item` object with the provided values.
    /// - Parameters:
    ///   - title: Title of the item
    ///   - media: The associated media (image)
    ///   - description: Description of the item
    ///   - dateTaken: Date the item(photo) was taken
    ///   - datePublished: Date the item(photo) was published
    ///   - tags: The associated tags
    init(_ title: String, _ media: Media, _ description: String, _ dateTaken: Date?, _ datePublished: Date?, _ tags: [String]?) {
        self.title = title
        self.media = media
        self.description = description
        self.dateTaken = dateTaken
        self.datePublished = datePublished
        self.tags = tags
    }
}

