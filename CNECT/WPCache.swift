//
//  WPCache.swift
//  CNECT
//
//  Created by Tobin Bell on 3/4/16.
//  Copyright © 2016 Tobin Bell. All rights reserved.
//

class WPCache {
    
    // Category caching
    var categories: [WPCategory]?
    var hasCategories: Bool {
        return categories != nil
    }
    
    // Tag caching.
    var tags: [WPTag]?
    var hasTags: Bool {
        return tags != nil
    }
    
    // Post caching.
    // Posts are stored as dictionaries for a certain subset, such as all posts, or posts within a certain category.
    private var posts = [WPPostSubset: [WPPost]]()
    
    func insert(categories: [WPCategory]) {
        uniquelyInsert(categories, into: &self.categories)
    }
    
    func insert(tags: [WPTag]) {
        uniquelyInsert(tags, into: &self.tags)
    }
    
    func insert(posts: [WPPost], forSubset subset: WPPostSubset) {
        uniquelyInsert(posts, into: &self.posts[subset])
    }
    
    func category(withID categoryID: Int) -> WPCategory? {
        guard let categories = categories else {
            return nil
        }
        
        // Linear search because there won't ever be more than a handful of categories.
        for category in categories {
            if category.ID == categoryID { return category }
        }
        
        return nil
    }
    
    func tag(withID tagID: Int) -> WPTag? {
        guard let tags = tags else {
            return nil
        }
        
        // Linear search because there won't ever be more than a handful of tags.
        for tag in tags {
            if tag.ID == tagID { return tag }
        }
        
        return nil
    }
    
    func posts(inSubset subset: WPPostSubset) -> [WPPost]? {
        return self.posts[subset]
    }
    
    private func uniquelyInsert<Element: WPObject>(objects: [Element], inout into container: [Element]?) {
        if container == nil {
            container = objects
            return
        }
        
        // Do not insert anything with an existing ID.
        for object in objects {
            if container!.contains({ element in object.ID == element.ID }) {
                continue
            }
            
            container!.append(object)
        }
    }
    
}