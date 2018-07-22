//
//  FlickrItem.swift
//  FlickrFetcherSDK
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Represents the item returned by Flickr API.
public class Item {
    //MARK:- Private Members
    private var _title: String!
    private var _media: Media!
    private var _description: String!
    private var _dateTaken: Date?
    private var _datePublished: Date?
    private var _tags: [String]?

    //MARK:- Initializers (Internal - Not needed outside SDK)
    /// Returns a newly initialized `Item` object with values fetched from the provided JSON Object.
    /// - Parameters:
    ///   - item: `SwiftyJSON`'s JSON object representing the item
    init(with item: JSON) {
        _title = item["title"].stringValue
        
        //We need atleast one type of image (which would always be present for each item of the public feed
        for key in item["media"].dictionaryValue.keys {
            _media = Media(with: item["media"][key].stringValue, key)
            break
        }
        
        _description = filterDescription(item["description"].stringValue)
        
        _dateTaken = Date.from(string: item["date_taken"].stringValue)
        _datePublished = Date.from(string: item["published"].stringValue, withFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'")
        if item["tags"].stringValue.count > 0 {
            _tags = item["tags"].stringValue.components(separatedBy: " ")
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
        _title = title
        _media = media
        _description = description
        _dateTaken = dateTaken
        _datePublished = datePublished
        _tags = tags
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
            let regex = try! NSRegularExpression.init(pattern: "<[^>]+>", options: .caseInsensitive)
            str = regex.stringByReplacingMatches(in: str, options: .reportCompletion, range: NSRange.init(location: 0, length: str.count), withTemplate: "")
        }
        
        return str.trimmingCharacters(in: .whitespaces)
    }
    
    //MARK:- Public Properties
    /// Name/Title of the item
    public var title: String {
        get {
            return _title
        }
    }
    
    /// Media of the Item. This provides us with the thumbnail and the image url.
    public var media: Media {
        get {
            return _media
        }
    }
    
    /// Description of the item
    public var description: String {
        get {
            return _description
        }
    }

    /// The date the item(image) was taken
    public var dateTaken: Date? {
        get {
            return _dateTaken
        }
    }

    /// The date the item was published to Flickr
    public var datePublished: Date? {
        get {
            return _datePublished
        }
    }

    /// The tags associated with the item
    public var tags: [String]? {
        get {
            return _tags
        }
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
