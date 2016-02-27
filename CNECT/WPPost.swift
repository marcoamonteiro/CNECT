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
    
    
    //"At some point" add error handling
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
        
        guard let dictPostImage = dict.valueForKey("featured_image_URL") as? String else {
            return nil
        }

        ID = dictID
        author = dictPostAuthor
        title = dictPostTitle
        content = dictPostContent
        authorName = dictPostAuthorName
        featuredImageURL = NSURL(string: dictPostImage)!
        
    }
}
