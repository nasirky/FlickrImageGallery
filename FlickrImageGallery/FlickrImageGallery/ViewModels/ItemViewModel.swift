//
//  ItemViewModel.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ItemViewModel {
    private var item: Item!

    //MARK:- Initializers
    init(with item: JSON) {
        self.item = Item(with: item)
    }

    init(with item: Item) {
        self.item = item
    }
    
    //MARK:- Internal Methods
    /// Filters the original description from the html string provided by Flickr.
    /// - Parameters:
    ///   - string: The description string (retreived from Flickr)
    /// - Returns: The description string without the unwanted html.
    private func filterDescription(_ string: String) -> String {
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
    
    //MARK:- Public properties
    public var title: String {
        return item.title
    }
    
    public var thumbnailUrl: URL? {
        return item.media.thumbnailUrl
    }
    
    public var imageUrl: URL? {
        return item.media.imageUrl
    }
    
    public var dateTaken: Date? {
        return item.dateTaken
    }
    
    public var datePublished: Date? {
        return item.datePublished
    }
    
    public var tags: [String]? {
        return item.tags
    }
    
    //MARK:- Public Methods
    public func description(stipHtml filtered: Bool) -> String {
        return filtered ? filterDescription(item.description) : item.description
    }

    /// Returns item object as array of optional `String`.
    /// - Parameters:
    ///   - format: The output format for the date string. It's an Optional parameter. Default value is yyyy-MM-dd HH:mm:ss xx.
    /// - Returns: The item as an array of optional `String`.
    public func itemAsArray(_ stripHtml: Bool,  dateFormat format: String? = "yyyy-MM-dd HH:mm:ss xx") -> [String?] {
        return [item.title, stripHtml ? filterDescription(item.description) : item.description, item.dateTaken?.toString(), item.datePublished?.toString(), item.tags?.joined(separator: ",")]
    }
}

extension ItemViewModel: Equatable {
    /// Mainly written for Unit Testing (to be able to use XCTAssertEqual).
    /// The best way to differentiate between items would be to assign them a unique id (however, since public feed does not return an item/image id, we are comparing all the elements to each other assuming that two items will not have the exact same data (especially dates (taken & published) and tags).
    /// Tags should be exactly in the same order for items to match (["test", "kitten"] would match ["test", "kitten"] but will not match ["kitten", "item"]
    public static func == (lhs: ItemViewModel, rhs: ItemViewModel) -> Bool {
        return lhs.itemAsArray(true).elementsEqual(rhs.itemAsArray(true))
    }
}

