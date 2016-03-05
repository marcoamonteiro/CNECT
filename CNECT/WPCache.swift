//
//  WPCache.swift
//  CNECT
//
//  Created by Tobin Bell on 3/4/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import Foundation

class WPCache {
    
    // Category caching
    private var fetchedCategories = false
    var categories = [WPCategory]()
    
    // Tag caching.
    private var fetchedTags = false
    var tags = [WPTag]()
    
    func insertCategories(categories: [WPCategory]) {
        self.categories.appendContentsOf(categories)
        fetchedCategories = true
    }
    
    func insertTags(tags: [WPTag]) {
        self.tags.appendContentsOf(tags)
        fetchedTags = true
    }
    
    func category(byID categoryID: Int) -> WPCategory? {
        // Linear search because there won't ever be more than a handful of categories.
        for category in categories {
            if category.ID == categoryID { return category }
        }
        
        return nil
    }
    
    func tag(byID tagID: Int) -> WPTag? {
        // Linear search because there won't ever be more than a handful of tags.
        for tag in tags {
            if tag.ID == tagID { return tag }
        }
        
        return nil
    }
    
}