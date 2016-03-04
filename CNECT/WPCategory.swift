//
//  WPCategory.swift
//  cnect
//
//  Created by Marco Monteiro on 2/21/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import Foundation

class WPCategory {
    let ID: Int
    let title: String
    let subtitle: String
    let tagline: String
    let parentID: Int?
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
            dictSubtitle            = dict["subtitle"] as? String,
            dictTagline             = dict["tagline"] as? String,
            dictParent              = dict["parent"] as? Int,
            dictSize                = dict["size"] as? Int,
            dictFeaturedImageURL    = dict["featuredImageURL"] as? String else {
                ID = 0
                title = ""
                subtitle = ""
                tagline = ""
                parentID = 0
                size = 0
                featuredImageURL = NSURL()
                return nil
        }
        
        ID = dictID
        title = dictTitle
        subtitle = dictSubtitle
        tagline = dictTagline
        parentID = dictParent != 0 ? dictParent : nil
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
