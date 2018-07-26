//
//  TaskProtocol.swift
//  FlickrImageGallery
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation

/// Represents a Task. Task is one unit of work (such as fetching public photos, user login etc.)
protocol Task {
    associatedtype T

    typealias successClosure = ((List) -> Void)?
    typealias failureClosure = ((_ error: String, _ tags: [String]?)->Swift.Void)?
    
    var request: Request {get}

    func execute(in service: Service,
                 onSuccess success: successClosure,
                 onFailure failure: failureClosure)
}
