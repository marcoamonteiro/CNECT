//
//  WPPost.swift
//  cnect
//
//  Created by Marco Monteiro on 2/25/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import UIKit

struct WPPost {
    var ID: Int
    var author: Int
    var authorName: String
    var featuredImageURL: NSURL
    var featuredImage: UIImage?
    var title: String
    var content: String
    
    /**
     * Construct a new WPPost object from an NSDictionary of data
     *
     * - parameter dict: An NSDictionary object containing the following fields: 'ID' (Int), 'post_author' (Int), 'post_title' (String), 'post_content' (String), 'post_author_name' (String), 'featured_image_URL' (String).
     */
    init?(dict: NSDictionary) {
        guard let dictID = dict.valueForKey("ID") as? Int else {
            return nil
        }
        
        guard let dictPostAuthor = dict.valueForKey("post_author") as? Int else {
            return nil
        }
        
        guard let dictPostTitle = dict.valueForKey("post_title") as? String else {
            return nil
        }
        
        guard let dictPostContent = dict.valueForKey("post_content") as? String else {
            return nil
        }
        
        guard let dictPostAuthorName = dict.valueForKey("post_author_name") as? String else {
            return nil
        }
        
        guard let dictFeaturedImageURL = dict.valueForKey("featured_image_URL") as? String else {
            return nil
        }

        ID = dictID
        author = dictPostAuthor
        title = dictPostTitle
        content = dictPostContent
        authorName = dictPostAuthorName
        featuredImageURL = NSURL(string: dictFeaturedImageURL)!
        
    }
}
