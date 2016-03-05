//
//  WPAPI.swift
//  cnect
//
//  Created by Marco Monteiro on 2/25/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import Foundation

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
        
        fetchCategories()
        fetchTags()
        fetchPosts()
    }
    
    private func fetchCategories() {
        let request = requestForAction("categories")
    }
    
    private func fetchTags() {
        
    }
    
    private func fetchPosts() {
        
    }
    
    private func requestForAction(action: String, withParameters parameters: [String: Any]? = nil) -> NSURLRequest {
        
        var path = "/wp-admin/admin-ajax.php?action=\(action)"
        
        if let parameters = parameters {
            for (key, value) in parameters {
                path += "&\(key)=\(value)"
            }
        }
        
        return NSURLRequest(URL: siteURL.URLByAppendingPathComponent(path))
    }
    
    private func executeRequest(request: NSURLRequest, forEachResult resultCallback: (AnyObject) -> Void) {
        let requestTask = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if error != nil { return }
            
            guard let data = data else {
                return completionBlock(nil)
            }
            
            do {
                if let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray {
                    for postJSON in JSON {
                        if let postDict = postJSON as? NSDictionary,
                            post = WPPost(dict: postDict) {
                                posts.append(post)
                        } else {
                            return completionBlock(nil)
                        }
                    }
                } else {
                    return completionBlock(nil)
                }
                
                // Perform callbacks on the main thread.
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completionBlock(posts)
                }
            } catch { completionBlock(nil) }
        }
        
        requestTask.resume()
    }
    
    /**
     * Retrieve a list of posts from Wordpress.
     *
     * - parameter completionBlock: A block to be performed upon completion of the request. The block should accept an optional array of WPPost structs as its parameter. If there was an error performing the request, this optional value will be nil.
     * - parameter category: An optional WPCategory object. If included, the returned posts will only be posts from that category.
     */
    func posts(inCategoryID categoryID: Int? = nil, completionBlock: ([WPPost]?) -> Void) {
        
        var posts = [WPPost]()
        
        var queryParameters = [String: Any]()
        
        if let categoryID = categoryID {
            queryParameters["categoryID"] = categoryID
        }
        
        let request = requestForAction("posts", withParameters: queryParameters)
        
        let requestTask = session.dataTaskWithRequest(request) { (data, response, error) in
            
            if error != nil {
                return completionBlock(nil)
            }
            
            guard let data = data else {
                return completionBlock(nil)
            }
            
            do {
                if let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray {
                    for postJSON in JSON {
                        if let postDict = postJSON as? NSDictionary,
                            post = WPPost(dict: postDict) {
                                posts.append(post)
                        } else {
                            return completionBlock(nil)
                        }
                    }
                } else {
                    return completionBlock(nil)
                }
                
                // Perform callbacks on the main thread.
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completionBlock(posts)
                }
            } catch { completionBlock(nil) }
        }
        
        requestTask.resume()
    }
    
    /**
     * Retrieve the list of categories from Wordpress.
     *
     * - parameter completionBlock: A block to be performed upon completion of the request. The block should accept an optional array of WPCategory structs as its parameter. If there was an error performing the request, this optional value will be nil.
     */
    func categories(completionBlock: ([WPCategory]?) -> Void) {
        var categories = [WPCategory]()
        
        let request = requestForAction("categories")
        
        let requestTask = session.dataTaskWithRequest(request) { (data, response, error) in
            if error != nil {
                return completionBlock(nil)
            }
            
            guard let data = data else {
                return completionBlock(nil)
            }
            
            do {
                if let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray {
                    for categoryJSON in JSON {
                        if let categoryDict = categoryJSON as? NSDictionary,
                            category = WPCategory(dict: categoryDict) {
                                categories.append(category)
                        } else {
                            return completionBlock(nil)
                        }
                    }
                } else {
                    return completionBlock(nil)
                }
                
                // Update the cache.
                for index in 0..<categories.count {
                    self.categories[index] = categories[index]
                }
                
                // Perform callbacks on the main thread.
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completionBlock(categories)
                }
            } catch {}
        }
        
        requestTask.resume()
    }
    
    /**
     * Retrieve the list of tags from Wordpress.
     *
     * - parameter completionBlock: A block to be performed upon completion of the request. The block should accept an optional array of WPTag objects as its parameter. If there was an error performing the request, this optional value will be nil.
     */
    func tags(completionBlock: ([WPTag]?) -> Void) {
        var tags = [WPTag]()
        
        let request = requestForAction("tags")
        
        let requestTask = session.dataTaskWithRequest(request) { (data, response, error) in
            if error != nil {
                return completionBlock(nil)
            }
            
            guard let data = data else {
                return completionBlock(nil)
            }
            
            do {
                if let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSArray {
                    for tagJSON in JSON {
                        if let tagDict = tagJSON as? NSDictionary,
                            tag = WPTag(dict: tagDict) {
                                tags.append(tag)
                        } else {
                            return completionBlock(nil)
                        }
                    }
                } else {
                    return completionBlock(nil)
                }
                
                // Update the cache.
                self.tags.appendContentsOf(tags)
                
                // Perform callbacks on the main thread.
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    completionBlock(tags)
                }
            } catch {}
        }
        
        requestTask.resume()
    }
    
}
