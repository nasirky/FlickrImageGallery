//
//  ListViewModel.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

class ListViewModel {
    //MARK: Private Members
    private var list: List! {
        didSet {
            self.lastUpdated = Date()
        }
    }
    
    private var service: ServiceProtocol?
    // Tags are used only when in the API calls so they do not belong to the model
    private var tags: [String]?
    
    private (set) var ttlInSeconds: Int
    private (set) var lastUpdated: Date

    //MARK - Public Member
    // SortOrder belongs to the ListViewModel so each instance of ListViewModel can have any of no, ascending or descending sorting. It is utilized by itemViewModels(onCompletion:) method to present itemViewModels to the user in the desired sorting.
    var sortOrder: SortOrder
    
    //MARK:- Initializers
    /// Returns a newly initialized `List` object  with an array of `Item` and the expiry time (optional with default value set to 0).
    /// - Parameters:
    ///   - service: The Service object (used for API call)
    ///   - tags: Tags for identifying the ListViewModel. tags are sent to the API
    ///   - sortOrder: SortOrder for the list
    ///   - ttl: The expiry time (in seconds). It denotes when ListViewModel refresh its list. The refresh does not occur automatically but when the method `itemViewModels(onCompletion:)` is called
    public init(with service: ServiceProtocol, forTags tags: [String]? = nil, sortBy sortOrder: SortOrder = .none, ttlInSeconds ttl: Int = 0) {
        self.service = service
        self.list = List(withItems: [Item]())
        self.tags = tags
        self.sortOrder = sortOrder
        self.ttlInSeconds = ttl
        self.lastUpdated = Date()
    }

    //MARK:- Initializers
    /// Returns a newly initialized `List` object  with an array of `Item` and the expiry time (optional with default value set to 0).
    /// - Parameters:
    ///   - list: The List model object
    ///   - tags: Tags for identifying the ListViewModel. tags are sent to the API
    ///   - sortOrder: SortOrder for the list
    ///   - ttl: The expiry time (in seconds). It denotes when ListViewModel refresh its list. The refresh does not occur automatically but when the method `itemViewModels(onCompletion:)` is called
    public init(with list: List, forTags tags: [String]?, sortBy sortOrder: SortOrder = .none, ttlInSeconds ttl: Int = 0) {
        self.list = list
        self.tags = tags
        self.sortOrder = sortOrder
        self.ttlInSeconds = ttl
        self.lastUpdated = Date()
    }
    
    /// Check if the ttl of the list has expired. The value of this property can either be true or false.
    /// - `true`: The application should refetch the (latest version) of list from Flickr
    /// - `false`: The application should load the already fetched version of the list
    public var hasExpired: Bool {
        guard let differenceInSeconds = Calendar.current.dateComponents([.second], from: lastUpdated, to: Date()).second  else {
            return false
        }
        
        return differenceInSeconds >= ttlInSeconds
    }
    
    /// Forcefully expire the List (Used to mark the list item to be redownloaded)
    public func expireForcefully() {
        self.lastUpdated = Date(timeIntervalSince1970: 0)
    }

    /// Returns ItemViewModel array for the ListViewModel. Fetches new list from the API in case the current one has expired or it has no items.
    public func itemViewModels(onCompletion completionHandler: @escaping ((_ itemViewModels: [ItemViewModel]?, _ error: String?)->Void)) {

        guard let service = service else {
            completionHandler(nil, "No Service attached")
            return
        }
        
        if list.items.count > 0 && !hasExpired {
            completionHandler(itemViewModels,nil)
            return
        }

        PublicPhotosTask(with: tags).execute(in: service, onSuccess: { list in
            self.list = list
            completionHandler(self.itemViewModels, nil)
        },  onFailure: { error in
            completionHandler(nil, error.localizedDescription)
        })
    }

    /// Returns ItemViewModel array for the ListViewModel afte performing the sorting
    /// The reasons for having ViewModel handle sorting are:
    ///  - I think sorting is more related to presentation than storage
    ///  - Makes it easier for the user to request a different sorting on the same list. All such requests are handled at ViewModel
    /// - Imagine a scenario where we store the list in a certain order (ascending or descending) and then we need to display it in the original order (it can be easily handled using this approach but in case we store sorted lists, we would need to refetch.
    public var itemViewModels: [ItemViewModel] {
        let items = sortOrder == .none ? list.items : list.items.sorted(by: sortOrder == .ascending ? sortAscending : sortDescending)
        
        let viewModels = items.map { item in
            ItemViewModel(with: item)
        }
        
        return viewModels
    }
    
    //MARK:- Internal functions
    /// Closure to sort the items in ascending order
    func sortAscending(_ first: Item, _ second: Item) -> Bool {
        return first.datePublished ?? Date() < second.datePublished ?? Date()
    }
    
    /// Closure to sort the items in descending order
    func sortDescending(_ first: Item, _ second: Item) -> Bool {
        return first.datePublished ?? Date() > second.datePublished ?? Date()
    }
}
