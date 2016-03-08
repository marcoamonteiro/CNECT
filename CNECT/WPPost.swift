//
//  WPPost.swift
//  cnect
//
//  Created by Tobin Bell on 2/25/16.
//  Copyright © 2016 Tobin Bell. All rights reserved.
//

import UIKit

class WPPost: WPObject {
    
    let ID: Int
    let title: String
    let excerpt: String
    let content: String
    
    let authorName: String
    let commentsCount: Int
    let categoryID: Int
    
    let featuredImageURL: NSURL
    private let featuredImageQueue = NSOperationQueue()
    private var featuredImageCache: UIImage?
    private var featuredImageFetched = false
    
    func featuredImage(completionHandler: (UIImage?) -> Void) {
        
        // Perform callbacks on the main thread to allow for UI updates.
        let complete = { image in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completionHandler(image)
            }
        }
        
        featuredImageQueue.qualityOfService = .UserInitiated
        featuredImageQueue.addOperationWithBlock {
            // If we have already fetched this image, simply return the cache.
            if self.featuredImageFetched {
                complete(self.featuredImageCache)
            }
            
            // Otherwise, go fetch it.
            if let data = NSData(contentsOfURL: self.featuredImageURL) {
                self.featuredImageFetched = true
                if let image = UIImage(data: data) {
                    self.featuredImageCache = image
                    complete(self.featuredImageCache)
                }
            }
        }
    }
    
    /**
     * Construct a new WPPost object from an NSDictionary of data
     *
     * - parameter dict: An NSDictionary object containing the following fields: 'ID' (Int), 'post_author' (Int), 'post_title' (String), 'post_content' (String), 'post_author_name' (String), 'featured_image_URL' (String).
     */
    required init?(dict: NSDictionary) {
        featuredImageQueue.maxConcurrentOperationCount = 1
        
        guard let dictID            = dict["ID"] as? Int,
            dictTitle               = dict["title"] as? String,
            dictExcerpt             = dict["excerpt"] as? String,
            dictContent             = dict["content"] as? String,
            dictFeaturedImageURL    = dict["featuredImageURL"] as? String,
            dictAuthorName          = dict["authorName"] as? String,
            dictCommentsCount       = dict["commentsCount"] as? Int,
            dictCategoryID          = dict["categoryID"] as? Int else {
                ID = 0
                title = ""
                excerpt = ""
                content = ""
                authorName = ""
                featuredImageURL = NSURL()
                commentsCount = 0
                categoryID = 0
                return nil
        }

        ID = dictID
        
        excerpt = dictExcerpt
        content = dictContent
        authorName = dictAuthorName
        
        commentsCount = dictCommentsCount
        categoryID = dictCategoryID
        
        if let asURL = NSURL(string: dictFeaturedImageURL) {
            featuredImageURL = asURL
        } else {
            title = ""
            featuredImageURL = NSURL()
            return nil
        }
        
        // Decode the HTML entitities embedded in the titles.
        let titleData = dictTitle.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let attributedOptions: [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute:        NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute:   NSUTF8StringEncoding
        ]
        
        do {
            let attributedString = try NSAttributedString(data: titleData, options: attributedOptions, documentAttributes: nil)
            title = attributedString.string
        } catch {
            title = ""
            return nil
        }
        
        // Begin fetching the featuredImage.
        featuredImage { _ in }
    }
}
