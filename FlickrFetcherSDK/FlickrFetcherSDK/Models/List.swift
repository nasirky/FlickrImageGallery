//
//  List.swift
//  FlickrFetcherSDK
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

/// Represents the list of items and the associated update time and expiry (in seconds)
public class List {
    //MARK:- Private Members
    private var _items: [Item]!
    private var _lastUpdated: Date
    private var _ttlInSeconds: Int
    
    //MARK:- Initializers
    /// Returns a newly initialized `List` object  with an array of `Item` and the expiry time (optional with default value set to 0).
    /// - Parameters:
    ///   - items: The list/array of `Item`
    ///   - ttl: The expiry time (in seconds). This property is used by `hasExpired`. The main purpose of this property is to limit the number of API(network) requests (as per the developer's preference). Setting it to 0 would force `hasExpired` to return `true` every time (asking the application to new API request)
    public init(with items:[Item],  expiresIn ttl: Int = 0) {
        _items = items
        _lastUpdated = Date()
        _ttlInSeconds = ttl
    }

    /// Returns a newly initialized `List` object  with an array of `Item`, sorted by the desired sortOrder.
    /// - Parameters:
    ///   - items: The list/array of `Item`
    ///   - sortOrder: The order (none, ascending, descending) to sort the items by (sorted by published date)
    public init(with items:[Item], sortBy sortOrder: SortOrder) {
        _lastUpdated = Date()
        _ttlInSeconds = 0
        
        _items = sortOrder == .none ? items : items.sorted(by: sortOrder == .ascending ? sortAscending : sortDescending)
    }

    /// Returns a newly initialized `List` object  with an array of `Item` and the expiry time (optional with default value set to 0).
    /// - Parameters:
    ///   - items: The list/array of `Item`
    ///   - sortOrder: The order (none, ascending, descending) to sort the items by. Published Date is used for this purpose.
    ///   - ttl: The expiry time (in seconds). This property is used by `hasExpired`. The main purpose of this property is to limit the number of API(network) requests (as per the developer's preference). Setting it to 0 would force `hasExpired` to return `true` every time (asking the application to new API request)
    public init(with items:[Item], sortBy sortOrder: SortOrder, expiresIn ttl: Int) {
        _lastUpdated = Date()
        _ttlInSeconds = ttl
        
        _items = sortOrder == .none ? items : items.sorted(by: sortOrder == .ascending ? sortAscending : sortDescending)
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
    
    //MARK:- Internal Properites (used by Unit Tests)
    var ttl: Int {
        get {
            return _ttlInSeconds
        }
    }
    
    //MARK:- Public Properties
    /// Array of items of the list
    public var items: [Item] {
        get {
            return _items
        }
    }
    
    /// Check if the ttl of the list has expired. The value of this property can either be true or false.
    /// - `true`: The application should refetch the (latest version) of list from Flickr
    /// - `false`: The application should load the already fetched version of the list
    public var hasExpired: Bool {
        guard let differenceInSeconds = Calendar.current.dateComponents([.second], from: _lastUpdated, to: Date()).second  else {
            return false
        }

        return differenceInSeconds >= _ttlInSeconds
    }
}
