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

    //MARK:- Initializers
    /// Returns a newly initialized `Item` object with values fetched from the provided JSON Object.
    /// - Parameters:
    ///   - item: `SwiftyJSON`'s JSON object representing the item
    public init(with item: JSON) {
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
}
