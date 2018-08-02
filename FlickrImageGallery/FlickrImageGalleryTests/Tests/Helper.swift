//
//  Helper.swift
//  FlickrImageGalleryTests
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
class Helper {
    func fetchFileContent(from fileName: String, withExtension fileExtension: String) -> String? {
        var fileContents: String?
        guard let filePath = Bundle(for: type(of: self)).path(forResource: fileName, ofType: fileExtension) else {
            return nil
        }
        
        do {
            fileContents = try String(contentsOfFile: filePath)
            return fileContents
        } catch( _) {
            return nil
        }
    }
}
