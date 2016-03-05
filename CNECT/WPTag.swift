//
//  WPTag.swift
//  cnect
//
//  Created by Tobin Bell on 3/4/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import Foundation

class WPTag: WPObject {
    let ID: Int
    let title: String
    let description: String
    let size: Int
    
    let featuredImageURL: NSURL
    private let featuredImageQueue = NSOperationQueue()
    private var featuredImageCache: UIImage?
    private var featuredImageFetched = false
    
    func featuredImage(completionBlock: (UIImage?) -> Void) {
        featuredImageQueue.qualityOfService = .UserInitiated
        featuredImageQueue.addOperationWithBlock {
            // If we have already fetched this image, simply return the cache.
            if self.featuredImageFetched {
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completionBlock(self.featuredImageCache)
                }
            }
            
            // Otherwise, go fetch it.
            if let data = NSData(contentsOfURL: self.featuredImageURL) {
                self.featuredImageFetched = true
                if let image = UIImage(data: data) {
                    self.featuredImageCache = image
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        completionBlock(self.featuredImageCache)
                    }
                }
            }
        }
    }
    
    init?(dict: NSDictionary) {
        guard let dictID            = dict["ID"] as? Int,
            dictTitle               = dict["title"] as? String,
            dictDescription         = dict["description"] as? String,
            dictSize                = dict["size"] as? Int,
            dictFeaturedImageURL    = dict["featuredImageURL"] as? String else {
                ID = 0
                title = ""
                description = ""
                size = 0
                featuredImageURL = NSURL()
                return nil
        }
        
        ID = dictID
        title = dictTitle
        description = dictDescription
        size = dictSize
        
        if let asURL = NSURL(string: dictFeaturedImageURL) {
            featuredImageURL = asURL
        } else {
            featuredImageURL = NSURL()
            return nil
        }
        
        // Begin fetching the featuredImage.
        featuredImage { _ in }
    }
}
