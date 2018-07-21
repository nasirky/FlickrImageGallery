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
    private var _items: [Item]
    private var _lastUpdated: Date
    private var _ttlInSeconds: Int
    
    //MARK:- Initializers
    /// Returns a newly initialized `List` object  with an array of `Item` and the expiry time (optional with default value set to 0).
    /// - Parameters:
    ///   - items: The list/array of `Item`
    ///   - ttl: The expiry time (in seconds). This property is used by `hasExpired`. The main purpose of this property is to limit the number of API(network) requests (as per the developer's preference). Setting it to 0 would force `hasExpired` to return `true` every time (asking the application to new API request)
    public init(with items:[Item], expiresIn ttl: Int = 0) {
        _items = items
        _lastUpdated = Date()
        _ttlInSeconds = ttl
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
        if let differenceInSeconds = Calendar.current.dateComponents([.second], from: _lastUpdated, to: Date()).second {
            return differenceInSeconds > _ttlInSeconds
        }
        
        return false
    }
}
