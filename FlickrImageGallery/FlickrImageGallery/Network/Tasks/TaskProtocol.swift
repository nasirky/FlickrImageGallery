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
    //Defined to give an idea of the user what type of object does this tasks returns
    associatedtype T

    typealias successClosure = ((T) -> Void)?
    typealias failureClosure = ((Error) -> Void)?
    
    var request: Request {get}

    func execute(in service: Service,
                 onSuccess success: successClosure,
                 onFailure failure: failureClosure)
}
