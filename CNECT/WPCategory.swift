//
//  WPCategory.swift
//  cnect
//
//  Created by Marco Monteiro on 2/21/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import Foundation

struct WPCategory {
    var ID: Int
    var name: String
    var count: Int
    var description: String
    var slug: String
    var parentID: Int?
    
    //"At some point" add error handling
    init?(dict: NSDictionary) {
        guard let dictID = dict.valueForKey("cat_ID") as? Int else {
            return nil
        }
        
        guard let dictName = dict.valueForKey("cat_name") as? String else {
            return nil
        }
        
        guard let dictCount = dict.valueForKey("category_count") as? Int else {
            return nil
        }
        
        guard let dictDescription = dict.valueForKey("category_description") as? String else {
            return nil
        }
        
        guard let dictSlug = dict.valueForKey("slug") as? String else {
            return nil
        }
        
        guard let dictParent = dict.valueForKey("parent") as? Int else {
            return nil
        }
        
        name = dictName
        count = dictCount
        description = dictDescription
        slug = dictSlug
        parentID = dictParent != 0 ? dictParent : nil
        ID = dictID
        
    }
}
