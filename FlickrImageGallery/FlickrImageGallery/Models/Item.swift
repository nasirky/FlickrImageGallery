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
        
        // Since there would be at least one key present, we do not need to handle the else condition
        if let key = Array(item["media"].dictionaryValue.keys).first {
            media = Media(with: item["media"][key].stringValue, key)
        }
        
        description = filterDescription(item["description"].stringValue)
        
        dateTaken = Date.from(string: item["date_taken"].stringValue)
        datePublished = Date.from(string: item["published"].stringValue, withFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'")
        if item["tags"].stringValue.count > 0 {
            tags = item["tags"].stringValue.components(separatedBy: " ")
        }
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

    
    //MARK:- Internal Methods
    /// Filters the original description from the html string provided by Flickr.
    /// - Parameters:
    ///   - string: The description string (retreived from Flickr)
    /// - Returns: The description string without the unwanted html.
    func filterDescription(_ string: String) -> String {
        var str = string
        
        //Step 1: Remove everything until and include </a></p>
        if let range = string.range(of: "</a></p>", options: .backwards, range: nil, locale: nil) {
            str.removeSubrange(str.startIndex..<range.upperBound)
        }
        
        //Step 2: Replacing <br/> with \n
        str = str.replacingOccurrences(of: "<br/>", with: "\n")
        
        //Step 3: Strip all other html tags (using regex <[^>]+>)
        if str.count > 0 {
            let regex = try! NSRegularExpression(pattern: "<[^>]+>", options: .caseInsensitive)
            str = regex.stringByReplacingMatches(in: str, options: .reportCompletion, range: NSRange(location: 0, length: str.count), withTemplate: "")
        }
        
        return str.trimmingCharacters(in: .whitespaces)
    }
    
    //MARK:- Public Methods
    /// Returns item object as array of optional `String`.
    /// - Parameters:
    ///   - format: The output format for the date string. It's an Optional parameter. Default value is yyyy-MM-dd HH:mm:ss xx.
    /// - Returns: The item as an array of optional `String`.
    public func asArray(dateFormat format: String? = "yyyy-MM-dd HH:mm:ss xx") -> [String?] {
        return [title, description, dateTaken?.toString(), datePublished?.toString(), tags?.joined(separator: ",")]
    }
    
    //MARK:- Internal copy methods (Used by Unit Tests)
    func copy() -> Item {
        let item = Item(title, media, description, dateTaken, datePublished, tags)
        
        return item
    }
    
    func copy(publishedOn datePublished:String) -> Item {
        let date = Date.from(string: datePublished, withFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'")
        let item = Item(title, media, description, dateTaken, date, tags)
        
        return item
    }
        
    func copy(withTags tags: [String]?) -> Item {
        let item = Item(title, media, description, dateTaken, datePublished, tags)
        
        return item
    }
}

extension Item: Equatable {
    /// Mainly written for Unit Testing (to be able to use XCTAssertEqual).
    /// The best way to differentiate between items would be to assign them a unique id (however, since public feed does not return an item/image id, we are comparing all the elements to each other assuming that two items will not have the exact same data (especially dates (taken & published) and tags).
    /// Tags should be exactly in the same order for items to match (["test", "kitten"] would match ["test", "kitten"] but will not match ["kitten", "item"]
    public static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.asArray().elementsEqual(rhs.asArray())
    }
}
