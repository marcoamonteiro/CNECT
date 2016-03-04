//
//  WPPost.swift
//  cnect
//
//  Created by Marco Monteiro on 2/25/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import UIKit

class WPPost {
    let ID: Int
    let title: String
    let excerpt: String
    let content: String
    
    let featuredImageURL: NSURL
    private let featuredImageQueue = NSOperationQueue()
    private var featuredImageCache: UIImage?
    private var featuredImageFetched = false
    
    func featuredImage(completionBlock: (UIImage?) -> Void) {
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
    
    let authorID: Int
    let authorName: String
    let commentsCount: Int
    let categoryID: Int
    
    /**
     * Construct a new WPPost object from an NSDictionary of data
     *
     * - parameter dict: An NSDictionary object containing the following fields: 'ID' (Int), 'post_author' (Int), 'post_title' (String), 'post_content' (String), 'post_author_name' (String), 'featured_image_URL' (String).
     */
    init?(dict: NSDictionary) {
        
        guard let dictID            = dict["ID"] as? Int,
            dictTitle               = dict["title"] as? String,
            dictExcerpt             = dict["excerpt"] as? String,
            dictContent             = dict["content"] as? String,
            dictFeaturedImageURL    = dict["featuredImageURL"] as? String,
            dictAuthorID            = dict["authorID"] as? Int,
            dictAuthorName          = dict["authorName"] as? String,
            dictCommentsCount       = dict["commentsCount"] as? Int,
            dictCategoryID          = dict["categoryID"] as? Int else {
                ID = 0
                title = ""
                excerpt = ""
                content = ""
                authorID = 0
                authorName = ""
                featuredImageURL = NSURL()
                commentsCount = 0
                categoryID = 0
                return nil
        }

        ID = dictID
        
        excerpt = dictExcerpt
        content = dictContent
        authorID = dictAuthorID
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
