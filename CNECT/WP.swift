//
//  WPAPI.swift
//  cnect
//
//  Created by Tobin Bell on 2/25/16.
//  Copyright © 2016 Tobin Bell. All rights reserved.
//

import Foundation
import UIKit

class WP {
    
    var siteURL: NSURL
    let session = NSURLSession.sharedSession()
    
    /**
     * Caching for various requests.
     */
    private var cache = WPCache()
    
    private let categoriesQueue = NSOperationQueue()
    private let tagsQueue = NSOperationQueue()
    private let postsQueue = NSOperationQueue()
    
    init(site: String) {
        siteURL = NSURL(string: site)!
        
        categoriesQueue.maxConcurrentOperationCount = 1
        tagsQueue.maxConcurrentOperationCount = 1
        postsQueue.maxConcurrentOperationCount = 1
    }
    
    func categories(completionHandler: ([WPCategory]?) -> Void) {
        
        // Perform the callback on the main thread.
        let complete = { categories in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completionHandler(categories)
            }
        }
        
        // First, check the cache.
        if let categories = cache.categories {
            return complete(categories)
        }
        
        // Place a web request.
        let request = requestFor("categories")
        execute(request) { JSON in
            var categories = [WPCategory]()
            
            guard let categoryDicts = JSON as? NSArray else {
                return complete(nil)
            }
            
            for categoryDict in categoryDicts {
                guard let dict = categoryDict as? NSDictionary,
                    category = WPCategory(dict: dict) else {
                        return complete(nil)
                }
                
                categories.append(category)
            }
            
            self.cache.insert(categories)
            complete(categories)
        }
    }
    
    func tags(completionHandler: ([WPTag]?) -> Void) {
        
        // Perform the callback on the main thread.
        let complete = { tags in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completionHandler(tags)
            }
        }
        
        // First, check the cache.
        if let tags = cache.tags {
            return complete(tags)
        }
        
        // Place a web request.
        let request = requestFor("tags")
        execute(request) { JSON in
            var tags = [WPTag]()
            
            guard let tagDicts = JSON as? NSArray else {
                return complete(nil)
            }
            
            for tagDict in tagDicts {
                guard let dict = tagDict as? NSDictionary,
                    tag = WPTag(dict: dict) else {
                        return complete(nil)
                }
                
                tags.append(tag)
            }
            
            self.cache.insert(tags)
            complete(tags)
        }
    }
    
    /**
     * Retrieve a list of posts from Wordpress.
     *
     * - parameter completionHandler: A block to be performed upon completion of the request. The block should accept an optional array of WPPost objects as its parameter. If there was an error performing the request, this optional value will be nil.
     * - parameter subset: A WPPostSubset struct detailing which posts to retrieve.
     */
    func posts(inSubset subset: WPPostSubset, completionHandler: ([WPPost]?) -> Void) {
        
        // Perform the callback on the main thread.
        let complete = { posts in
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completionHandler(posts)
            }
        }
        
        // First, check the cache.
        if let posts = cache.posts(inSubset: subset) {
            return complete(posts)
        }
        
        // Place a web request.
        var queryParameters = [String: Any]()
        
        if let categoryID = subset.categoryID {
            queryParameters["categoryID"] = categoryID
        }
        
        if let tagID = subset.tagID {
            queryParameters["tagID"] = tagID
        }
        
        let request = requestFor("posts", withParameters: queryParameters)
        
        execute(request) { JSON in
            var posts = [WPPost]()
            
            guard let postDicts = JSON as? NSArray else {
                return complete(nil)
            }
            
            for postDict in postDicts {
                guard let dict = postDict as? NSDictionary,
                    post = WPPost(dict: dict) else {
                    return complete(nil)
                }
                
                posts.append(post)
            }
            
            self.cache.insert(posts, forSubset: subset)
            complete(posts)
        }
    }
    
    // Retrieve a single category by its ID.
    func category(withID categoryID: Int) -> WPCategory? {
        // First check the cache. If the cache has any categories, then simply return whether or not the cache has this category, since categories (and tags) are fetched and inserted all at once.
        if cache.hasCategories {
            return cache.category(withID: categoryID)
        }
        
        // Request from the server.
        categories { _ in }
        return cache.category(withID: categoryID)
    }
    
    func tag(withID tagID: Int) -> WPTag? {
        // First check the cache. If the cache has any tags, then simply return whether or not the cache has this tag, since tags (and categories) are fetched and inserted all at once.
        if cache.hasTags {
            return cache.tag(withID: tagID)
        }
        
        // Request from the server.
        tags { _ in }
        return cache.tag(withID: tagID)
    }
    
    private func requestFor(action: String, withParameters parameters: [String: Any]? = [:]) -> NSURLRequest {
        
        var path = "/wp-admin/admin-ajax.php?action=\(action)"
        
        if let parameters = parameters {
            for (key, value) in parameters {
                path += "&\(key)=\(value)"
            }
        }
        
        return NSURLRequest(URL: siteURL.URLByAppendingPathComponent(path))
    }
    
    /**
     * Generically performs a request.
     */
    private func execute(request: NSURLRequest, onCompletion completionHandler: (AnyObject?) -> Void) {
        
        let requestTask = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if error != nil { return completionHandler(nil) }
            
            guard let data = data else {
                return completionHandler(nil)
            }
            
            do {
                return completionHandler(try NSJSONSerialization.JSONObjectWithData(data, options: []))
            } catch { completionHandler(nil) }
        }
        
        requestTask.resume()
    }
    
}
