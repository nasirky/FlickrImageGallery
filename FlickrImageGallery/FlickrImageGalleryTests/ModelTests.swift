//
//  ModelTests.swift
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import XCTest

@testable import FlickrImageGallery
@testable import SwiftyJSON

/// Testing that the models are correctly created and initiliazed
class ModelTests: XCTestCase {
    var urlString: String!
    
    var item: Item!
    var itemDict: [String: Any]!
    var media: Media!
    
    override func setUp() {
        super.setUp()
        
        // Setting up test data
        urlString = Urls.FlickrApi.feeds.appending("pictures/test_m.jpg")
        media = Media(with: urlString, "m")
        
        itemDict = ["title" : "First Item",
                    "media" : ["m" : urlString],
                    "description" : "",
                    "date_taken" : "2018-07-22T11:25:30+0200",
                    "published" : "2018-07-22T11:25:45Z",
                    "tags" : "kitten kittens test"]
        item = Item(with: JSON(itemDict))
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // Test creation of the media (to make sure the urls are being generated correctly)
    func testMediaCreation() {
        XCTAssertEqual(media.urlString, "https://api.flickr.com/services/feeds/pictures/test")
        XCTAssertEqual(media.imageExtension, "jpg")
        
        XCTAssertEqual(media.imageUrl, URL(string: urlString.replacingOccurrences(of: "_m", with: Media.imageSuffix)))
        XCTAssertEqual(media.thumbnailUrl, URL(string: urlString.replacingOccurrences(of: "_m", with: Media.thumbnailSuffix)))
    }

    // Test item creation (to make sure the item is created and (all fields are) initialized correctly)
    func testItemCreation() {
        XCTAssertEqual(item.title, itemDict["title"] as? String)
        XCTAssertEqual(item.media.urlString, media.urlString)
        XCTAssertEqual(item.media.imageExtension, media.imageExtension)
        XCTAssertEqual(item.description, itemDict["description"] as? String)
        
        let dateTakenString = itemDict["date_taken"] as! String
        XCTAssertEqual(item.dateTaken, Date.from(string: dateTakenString))
        
        let datePublishedString = itemDict["published"] as! String
        XCTAssertEqual(item.datePublished, Date.from(string: datePublishedString, withFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'"))

        // Trying to convert date strings (taken and published) to date using wrong format (any format other than their original one). In this case, I am using published date's format for taken date and vice versa.
        XCTAssertNotEqual(item.dateTaken, Date.from(string: dateTakenString, withFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'"))
        XCTAssertNotEqual(item.datePublished, Date.from(string: datePublishedString))
        
        XCTAssertEqual(item.tags, (itemDict["tags"] as! String).components(separatedBy: " "))
    }
    
    // Test the Item copy methods are working fine
    func testItemCopy() {
        let items = [item,
                     item.copy(),
                     item.copy(withTags: nil),
                     item.copy(publishedOn: "2018-07-22T11:25:45Z"), //same publish date as item
                     item.copy(publishedOn: "2018-07-22T11:25:46Z"), //different published date(seconds increased by 1)
                     item.copy(withTags: ["kitten", "kittens","test"]), // Using same tags as item
                     item.copy(withTags: ["test", "kitten", "kittens"])] // Using same tags but in different order
        
        XCTAssertEqual(item, items[1])
        
        XCTAssertNotEqual(item, items[2])
        XCTAssertNotEqual(items[2], items[3])
        
        XCTAssertEqual(item, items[3])
        XCTAssertEqual(items[1], items[3])
        
        XCTAssertNotEqual(item, items[4])
        XCTAssertNotEqual(items[3], items[4])
        
        XCTAssertEqual(item.tags, items[5]?.tags)
        XCTAssertEqual(item, items[5])
        
        // Tags should be in the same order otherwise Items are classified as different
        XCTAssertNotEqual(item.tags, items[6]?.tags)
        XCTAssertNotEqual(item, items[6])
    }

    func testListCreationAndExpiry() {
        let list = List(withItems: [item,
                               item.copy(),
                               item.copy(withTags: nil)],
                        expiresIn: 20)
        
        let list1 = List(withItems: [item])
        
        XCTAssertNotNil(list)
        XCTAssertTrue(list.items.count == 3)
        XCTAssertFalse(list.hasExpired)
        XCTAssertEqual(list.ttlInSeconds, 20)
        
        XCTAssertNil(list.items.last?.tags)
        
        XCTAssertTrue(list1.hasExpired)
    }
    
    /// Tests the list sorting functionality. Testing all the three sorting types (none, ascending and descending) in the same test
    func testListSorting() {
        let items: [Item] = [item,
                             item.copy(publishedOn: "2018-07-22T11:25:43Z"),
                             item.copy(publishedOn: "2018-07-21T11:30:45Z"),
                             item.copy(publishedOn: "2018-07-22T12:11:12Z")]

        //sortOrder: none
        var list = List(withItems: items, sortBy: .none)
        var sortedItems = items

        XCTAssertTrue(sortedItems.elementsEqual(list.items))

        //sortOrder: ascending
        list = List(withItems: items, sortBy: .ascending)
        sortedItems = [items[2], items[1], items[0], items[3]]
        
        XCTAssertTrue(sortedItems.elementsEqual(list.items))

        //sortOrder: descending
        list = List(withItems: items, sortBy: .descending)
        sortedItems = [items[3], items[0], items[1], items[2]]
        
        XCTAssertTrue(sortedItems.elementsEqual(list.items))
    }
}
