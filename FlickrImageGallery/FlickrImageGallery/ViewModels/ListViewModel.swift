//
//  ListViewModel.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
class ListViewModel {
    private var list: List!
    
    var lastUpdated: Date!
    var ttlInSeconds: Int
    
    private var service = Service(with: Urls.FlickrApi.feeds)

    //MARK:- Initializers
    
    public init(expiry ttl: Int = 0) {
        ttlInSeconds = ttl
        update(withList: List(withItems: [Item]()))
    }
    
    /// Returns a newly initialized `List` object  with an array of `Item` and the expiry time (optional with default value set to 0).
    /// - Parameters:
    ///   - items: The list/array of `Item`
    ///   - sortOrder: The order (none, ascending, descending) to sort the items by. Published Date is used for this purpose.
    ///   - ttl: The expiry time (in seconds). This property is used by `hasExpired`. The main purpose of this property is to limit the number of API(network) requests (as per the developer's preference). Setting it to 0 would force `hasExpired` to return `true` every time (asking the application to new API request)
    public init(withList list: List, expiry ttl: Int = 0) {
        ttlInSeconds = ttl
        update(withList: list)
    }
    
    func update(withList list: List) {
        lastUpdated = Date()
        self.list = list
    }
    
    func expireForcefully() {
        self.lastUpdated = Date(timeIntervalSince1970: 0)
    }
    
    /// Check if the ttl of the list has expired. The value of this property can either be true or false.
    /// - `true`: The application should refetch the (latest version) of list from Flickr
    /// - `false`: The application should load the already fetched version of the list
    var hasExpired: Bool {
        guard let differenceInSeconds = Calendar.current.dateComponents([.second], from: lastUpdated, to: Date()).second  else {
            return false
        }
        
        return differenceInSeconds >= ttlInSeconds
    }

    // I think sorting is more of presentation layer handling, so have added it to the ViewModel
    // So the Model is storing items in the original order and the ViewModel is taking care of the sorting on the fly
    func itemViewModels(sortBy sortOrder: SortOrder = .none) -> [ItemViewModel] {
        let items = sortOrder == .none ? list.items : list.items.sorted(by: sortOrder == .ascending ? sortAscending : sortDescending)

        let itemViewModels = items.map { item in
            ItemViewModel(with: item)
        }
            
        return itemViewModels
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
