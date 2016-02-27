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
    
    func getPosts(inCategory category: WPCategory? = nil, completionBlock: ([WPPost]?) -> Void) {
        
        var posts = [WPPost]()
        
        var queryParameters = [String: Any]()
        
        queryParameters["catID"] = category?.ID ?? 0
        
        let request = requestForAction("get_posts", withParameters: queryParameters)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            if error != nil {
                completionBlock(nil)
                return
            }
            
            do {
                if let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSArray {
                    for postJSON in JSON {
                        if let postDict = postJSON as? NSDictionary {
                            if let post = WPPost(dict: postDict) {
                                posts.append(post)
                            } else {
                                completionBlock(nil)
                                return
                            }
                        } else {
                            completionBlock(nil)
                            return
                        }
                    }
                    
                } else {
                    completionBlock(nil)
                    return
                }
                completionBlock(posts)
            } catch {}
        }
    }
    
    func getCategories(completionBlock: ([WPCategory]?) -> Void) {
        var categories = [WPCategory]()
        
        let request = requestForAction("get_categories")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            if error != nil {
                completionBlock(nil)
            }
            do {
                if let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    for (_, value) in JSON {
                        categories.append(WPCategory(dict: value as! NSDictionary)!)
                    }
                } else {
                    completionBlock(nil)
                }
                completionBlock(categories)
            } catch {}
        }
    }
}

let cnect = WP(site: "http://cnect.co")

//cnect.get