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
class ViewModelTests: XCTestCase {
    var urlString: String!

    var item: Item!
    var itemViewModel: ItemViewModel!
    var itemDict: [String: Any]!
    var media: Media!
    
    var helper: Helper?
    
    override func setUp() {
        super.setUp()
        
        // Setting up test data
        urlString = Urls.FlickrApi.feeds.appending("pictures/test_m.jpg")
        itemDict = ["title" : "First Item",
                    "media" : ["m" : urlString],
                    "description" : "",
                    "date_taken" : "2018-07-22T11:25:30+0200",
                    "published" : "2018-07-22T11:25:45Z",
                    "tags" : "kitten kittens test"]

        let itemDictJSON = JSON(itemDict)
        media = Media(with: itemDictJSON)
        
        item = Item(with: itemDictJSON)
        itemViewModel = ItemViewModel(with: item)
        
        helper = Helper()
    }
    
    override func tearDown() {
        super.tearDown()
        helper = nil
    }
    
    // Test creation of the media (to make sure the urls are being generated correctly)
    func testMediaCreation() {
        XCTAssertEqual(media.urlString, "https://api.flickr.com/services/feeds/pictures/test")
        XCTAssertEqual(media.imageExtension, "jpg")
        
        XCTAssertEqual(media.imageUrl, URL(string: urlString.replacingOccurrences(of: "_m", with: Media.ImageSuffix)))
        XCTAssertEqual(media.thumbnailUrl, URL(string: urlString.replacingOccurrences(of: "_m", with: Media.ThumbnailSuffix)))
    }

    // Test item creation (to make sure the item is created and (all fields are) initialized correctly)
    func testItemCreation() {
        XCTAssertEqual(itemViewModel.title, itemDict["title"] as? String)
        XCTAssertEqual(itemViewModel.description(stipHtml: false), itemDict["description"] as? String)
        
        let dateTakenString = itemDict["date_taken"] as! String
        XCTAssertEqual(itemViewModel.dateTaken, Date.from(string: dateTakenString))
        
        let datePublishedString = itemDict["published"] as! String
        XCTAssertEqual(itemViewModel.datePublished, Date.from(string: datePublishedString, withFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'"))

        // Trying to convert date strings (taken and published) to date using wrong format (any format other than their original one). In this case, I am using published date's format for taken date and vice versa.
        XCTAssertNotEqual(itemViewModel.dateTaken, Date.from(string: dateTakenString, withFormat: "yyyy-MM-dd'T'HH:mm:ss'Z'"))
        XCTAssertNotEqual(itemViewModel.datePublished, Date.from(string: datePublishedString))
        
        XCTAssertEqual(itemViewModel.tags, (itemDict["tags"] as! String).components(separatedBy: " "))
    }
    
    func testListCreationAndExpiry() {
        let list = List(withItems: [item,
                               Item(with: item),
                               Item(with: item, forTags: nil)])
        let list1 = List.init(withItems: [item])
        
        let listViewModel = ListViewModel(with: list, forTags: nil)
        let listViewModel1 = ListViewModel(with: list1, forTags: nil, sortBy: .none, ttlInSeconds: 20)
        
        XCTAssertTrue(listViewModel.itemViewModels.count == 3)
        XCTAssertTrue(listViewModel.hasExpired)

        XCTAssertFalse(listViewModel1.hasExpired)
        XCTAssertEqual(listViewModel1.ttlInSeconds, 20)
    }
    
    /// Tests the list sorting functionality. Testing all the three sorting types (none, ascending and descending) in the same test
    func testListSorting() {
        let items: [Item] = [item,
                             Item(with: item, publishedOn: "2018-07-22T11:25:43Z"),
                             Item(with: item, publishedOn: "2018-07-21T11:30:45Z"),
                             Item(with: item, publishedOn: "2018-07-22T12:11:12Z")]

        var itemViewModels = items.map({ item in
            return ItemViewModel(with: item)
        })

        let list = List(withItems: items)

        // Generating ListViewModels for no, ascending and descending sorting
        let listViewModel = ListViewModel.init(with: list, forTags: nil)
        let listViewModelSortedAscending = ListViewModel(with: list, forTags:nil, sortBy: .ascending)
        let listViewModelSortedDescending = ListViewModel(with: list, forTags:nil, sortBy: .descending)

        //sortOrder: none
        var sortedItemViewModels = itemViewModels
        XCTAssertTrue(sortedItemViewModels.elementsEqual(listViewModel.itemViewModels))

        //sortOrder: ascending
        sortedItemViewModels = [itemViewModels[2], itemViewModels[1], itemViewModels[0], itemViewModels[3]]
        XCTAssertTrue(sortedItemViewModels.elementsEqual(listViewModelSortedAscending.itemViewModels))

        //sortOrder: descending
        sortedItemViewModels = [itemViewModels[3], itemViewModels[0], itemViewModels[1], itemViewModels[2]]
        XCTAssertTrue(sortedItemViewModels.elementsEqual(listViewModelSortedDescending.itemViewModels))
    }
    
    func testPopulateListViewModelFromMockedService() {
        guard let fileContents = helper?.fetchFileContent(from: "public_photo_stream_response", withExtension: "json") else {
            XCTFail("Error reading file")
            return
        }

        let mockedService = MockedService(with: fileContents)
        let listViewModel = ListViewModel(with: mockedService)

        let testExpectation = expectation(description: "Expecting ItemViewModels from ListViewModel")

        listViewModel.itemViewModels { (itemViewModels, error) in
            testExpectation.fulfill()

            XCTAssertNil(error)
            XCTAssertNotNil(itemViewModels)
            
            XCTAssertEqual(itemViewModels?.count, 20)    // we have 20 items in the mocked response
            XCTAssertEqual(itemViewModels![0].title, "Test post 1")
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                XCTFail("Error :\(error)")
            }
        }
    }
}
