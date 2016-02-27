//
//  WPAPI.swift
//  cnect
//
//  Created by Marco Monteiro on 2/25/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import Foundation

class WP {
    
    var siteURL: String
    let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    init(site: String) {
        siteURL = site
    }
    
    private func requestForAction(action: String, withParameters parameters: [String: Any]? = nil) -> NSURLRequest {
        var URL = "\(siteURL)/wp-admin/admin-ajax.php?action=\(action)"
        
        if let parameters = parameters {
            for (key, value) in parameters {
                URL += "&\(key)=\(value)"
            }
        }
        
        return NSURLRequest(URL: NSURL(string: URL)!)
    }
    
    /**
     * Retrieve a list of posts from Wordpress.
     *
     * - parameter completionBlock: A block to be performed upon completion of the request. The block should accept an optional array of WPPost structs as its parameter. If there was an error performing the request, this optional value will be nil.
     * - parameter category: An optional WPCategory object. If included, the returned posts will only be posts from that category.
     */
    func getPosts(inCategory category: WPCategory? = nil, completionBlock: ([WPPost]?) -> Void) {
        
        var posts = [WPPost]()
        
        var queryParameters = [String: Any]()
        
        queryParameters["catID"] = category?.ID ?? 0
        
        let request = requestForAction("get_posts", withParameters: queryParameters)
        
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
                        if let postDict = postJSON as? NSDictionary {
                            if let post = WPPost(dict: postDict) {
                                posts.append(post)
                            } else {
                                return completionBlock(nil)
                            }
                        } else {
                            return completionBlock(nil)
                        }
                    }
                    
                } else {
                    return completionBlock(nil)
                }
                completionBlock(posts)
            } catch {}
        }
        
        requestTask.resume()
    }
    
    /**
     * Retrieve the list of categories from Wordpress.
     *
     * - parameter completionBlock: A block to be performed upon completion of the request. The block should accept an optional array of WPCategory structs as its parameter. If there was an error performing the request, this optional value will be nil.
     */
    func getCategories(completionBlock: ([WPCategory]?) -> Void) {
        var categories = [WPCategory]()
        
        let request = requestForAction("get_categories")
        
        let requestTask = session.dataTaskWithRequest(request) { (data, response, error) in
            if error != nil {
                return completionBlock(nil)
            }
            
            guard let data = data else {
                return completionBlock(nil)
            }
            
            do {
                if let JSON = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary {
                    for (_, categoryJSON) in JSON {
                        if let categoryDict = categoryJSON as? NSDictionary {
                            if let category = WPCategory(dict: categoryDict) {
                                categories.append(category)
                            } else {
                                return completionBlock(nil)
                            }
                        } else {
                            return completionBlock(nil)
                        }
                    }
                } else {
                    return completionBlock(nil)
                }
                completionBlock(categories)
            } catch {}
        }
        
        requestTask.resume()
    }
}
