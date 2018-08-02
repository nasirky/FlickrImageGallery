//
//  List.swift
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

/// Represents the list of items and the associated update time and expiry (in seconds)
public class List {
    //MARK:- Private Members
    private (set) var items: [Item]
    
    //MARK:- Initializers
    /// Returns a newly initialized `List` object  with an array of `Item` and the expiry time (optional with default value set to 0).
    /// - Parameters:
    ///   - items: The list of items
    public init(withItems items:[Item]) {
        self.items = items
    }    
}
