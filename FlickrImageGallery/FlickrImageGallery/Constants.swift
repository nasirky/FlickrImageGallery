//
//  Constants.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct TableView {
        static let Headers = ["Kittens", "Dogs", "Public Feed", "Beaches", "Lakes"]
        static let Tags = [["kitten","kittens"],["dog","dogs"],nil,["beach","beaches","sand"], ["lake","lakes"]]
        
        static let ItemSortOrder = SortOrder.none
        static let Ttl = 0

        struct Height {
            static let Header: CGFloat = 40
            static let Footer: CGFloat = 40
        }
    }
    
    struct Identifiers {
        static let ListCell = "ListCell"
        static let ListItemCell = "ListItemCell"
        static let InfoCell = "InfoCell"
        static let ShowDetailVC = "ShowDetailVC"
    }
    
    struct Notifications {
        static let ItemSelected = "DidSelectListItem"
    }

    struct Info {
        static let Headings = ["Title", "Description", "Date Taken", "Date Published", "Tags"]
    }
    
    struct Messages {
        struct Error {
            static let OpenInBrowser = "Oops... Looks like we cannot open this image in browser. Please try another image."
            static let Share = "Please wait for the image to complete loading and then try again."
        }
    }
    
    struct Titles {
        static let Info = "Item Details"
    }
    
    struct API {
        struct Response {
            static let Failure = "fail"
        }
    }
}
