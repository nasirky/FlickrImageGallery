//
//  PublicService.swift
//  FlickrFetcherSDK
//
//  Created by Ghulam Nasir.
//  Copyright © 2018 Ghulam Nasir. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

/// Container for all the Public services. At this moment, it only contains the service to fetch items from public photo stream
public class PublicService {
    public static let sharedInstance = PublicService()
    
    /// Fetches the public photos and and (optional) `success` callback that returns the results as array of `Item` objects and the input tags (tags provided to the service by the calling application) and an (optional) `failure` callback that returns the error string and the inptu tags.
    /// - Parameters:
    ///   - tags: The input tags (will be passed as parameter to the service if provided).
    ///   - success: The (optional) success callback returning an array of fetched items and the input tags.
    ///   - failure: The (optional) failure callback returning the error string and the input tags. The input tags are returned if the application wants to retry the request.
    public func fetchPublicPhotos(with tags: [String]?, onSuccess success: ((_ items: [Item], _ tags: [String]?) -> ())? = nil, onFailure failure: ((_ error: String, _ tags: [String]?)->())? = nil) {
        //nojsoncallback is added so that the json response is not wrapped inside jsonFlickrFeed()
        var parameters: Parameters = [ "format" : "json",
                                       "tagmode" : "any",    //return public photos matching any of the provided tags
                                       "nojsoncallback" : "1"]
        if let tags = tags {
            parameters["tags"] = tags.joined(separator: ",")    //Flickrs' public feed API takes commas separated tags as input
        }
        
        Alamofire.request(PublicServiceUrls.publicPhotos, parameters: parameters).responseString { response in
            switch(response.result) {
            case .success:
                guard let data = response.data, response.error == nil else {
                    failure?(response.error?.localizedDescription ?? "An error has occured", tags)
                    return
                }

                // response can either have error or data (in case there is no error, then there should definitely be data), that why I am force unwrapping response.data
                do {
                    let json = try JSON(data: data)
                    let itemsJSON = json["items"].arrayValue
                    
                    let items = itemsJSON.map({ itemJSON in
                        return Item(with: itemJSON)
                    })
                        
                    success?(items, tags)
                } catch (let error) {
                    failure?(error.localizedDescription, tags)
                }
            case .failure(let error):
                failure?(error.localizedDescription, tags)
            }
        }
    }
}
