//
//  Date.swift
//  FlickrFetcherSDK
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

/// Extension for Foundations' Date class to provide missing functionality such as a function for converting String to Date
extension Date {
    /// Returns a newly initialzed Date object generated from the input string and date format. Returns nil if the date string or format is invalid.
    /// - Parameters:
    ///   - string: The string representation of the date
    ///   - format: The date format for the input date string. Default format is `yyyy-MM-dd'T'HH:mm:ssxx`
    /// - Returns: an optional date object (which will be `nil` if either the input string or date format are not compatible
    static func from(string value: String, withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssxx") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.date(from: value)
    }
    
    func toString(withFormat format: String = "yyyy-MM-dd HH:mm:ss zzz") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
}
