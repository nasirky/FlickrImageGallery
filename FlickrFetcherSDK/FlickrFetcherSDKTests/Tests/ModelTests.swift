//
//  FlickrFetcherSDKTests.swift
//  FlickrFetcherSDKTests
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import XCTest

@testable import FlickrFetcherSDK
@testable import SwiftyJSON

/// Testing that the models are correctly created and initiliazed
class ModelTests: XCTestCase {
    var urlString: String!
    
    var item: Item!
    var itemDict: [String: Any]!
    var media: Media!
    
    override func setUp() {
        super.setUp()
        
        urlString = Urls.feeds.appending("pictures/test_m.jpg")
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
    
    func testMediaCreation() {
        XCTAssertEqual(media.urlString, "https://api.flickr.com/services/feeds/pictures/test")
        XCTAssertEqual(media.imageExtension, "jpg")
        
        XCTAssertEqual(media.imageUrl, URL(string: urlString.replacingOccurrences(of: "_m", with: Media.imageSuffix)))
        XCTAssertEqual(media.thumbnailUrl, URL(string: urlString.replacingOccurrences(of: "_m", with: Media.thumbnailSuffix)))
    }

    func testItemCreation() {
        XCTAssertEqual(item.title, itemDict["title"] as! String)
        XCTAssertEqual(item.media.urlString, media.urlString)
        XCTAssertEqual(item.media.imageExtension, media.imageExtension)
        XCTAssertEqual(item.description, itemDict["description"] as! String)
        
        let dateTakenString = itemDict["date_taken"] as! String
        XCTAssertEqual(item.dateTaken, Date.from(string: dateTakenString))
        XCTAssertNotEqual(item.dateTaken, Date.from(string: dateTakenString, withFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'"))
        
        let datePublishedString = itemDict["published"] as! String
        XCTAssertNotEqual(item.datePublished, Date.from(string: datePublishedString))
        XCTAssertEqual(item.datePublished, Date.from(string: datePublishedString, withFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'"))
        
        XCTAssertEqual(item.tags, (itemDict["tags"] as! String).components(separatedBy: " "))
    }
    
    func testItemCopy() {
        let item1 = item.copy()
        let item2 = item.copy(withTags: nil)
        let item3 = item.copy(publishedOn: "2018-07-22T11:25:45Z")  //same publish date as item
        let item4 = item.copy(publishedOn: "2018-07-22T11:25:46Z")  //different published date(seconds increased by 1)
        
        XCTAssertEqual(item, item1)
        
        XCTAssertNotEqual(item, item2)
        XCTAssertNotEqual(item2, item3)
        
        XCTAssertEqual(item, item3)
        XCTAssertEqual(item1, item3)
        
        XCTAssertNotEqual(item, item4)
        XCTAssertNotEqual(item3, item4)
        
    }

    func testListCreationAndExpiry() {
        let list = List(with: [item,
                               item.copy(),
                               item.copy(withTags: nil)],
                        expiresIn: 20)
        
        let list1 = List(with: [item])
        
        XCTAssertNotNil(list)
        XCTAssertTrue(list.items.count == 3)
        XCTAssertFalse(list.hasExpired)
        XCTAssertEqual(list.ttl, 20)
        
        XCTAssertNil(list.items.last?.tags)
        
        XCTAssertTrue(list1.hasExpired)
    }
    
    /// Tests the list sorting functionality. Testing all the three sorting types (none, ascending and descending) in the same test
    func testListSorting() {
        let item1 = item.copy(publishedOn: "2018-07-22T11:25:43Z")
        let item2 = item.copy(publishedOn: "2018-07-21T11:30:45Z")
        let item3 = item.copy(publishedOn: "2018-07-22T12:11:12Z")

        let items: [Item] = [item, item1, item2, item3]

        //sortOrder: none
        var list = List(with: items, sortBy: .none)
        var listItems = list.items
        
        XCTAssertEqual(item, listItems[0])
        XCTAssertEqual(item1, listItems[1])
        XCTAssertEqual(item2, listItems[2])
        XCTAssertEqual(item3, listItems[3])

        //sortOrder: descending
        list = List(with: items, sortBy: .ascending)
        listItems = list.items
        
        XCTAssertEqual(item2, listItems[0])
        XCTAssertEqual(item1, listItems[1])
        XCTAssertEqual(item, listItems[2])
        XCTAssertEqual(item3, listItems[3])
        
        //sortOrder: descending
        list = List(with: items, sortBy: .descending)
        listItems = list.items
        
        XCTAssertEqual(item3, listItems[0])
        XCTAssertEqual(item, listItems[1])
        XCTAssertEqual(item1, listItems[2])
        XCTAssertEqual(item2, listItems[3])
    }
}
