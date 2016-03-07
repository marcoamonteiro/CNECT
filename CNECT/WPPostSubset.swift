//
//  WPPostSubset.swift
//  CNECT
//
//  Created by Tobin Bell on 3/5/16.
//  Copyright © 2016 Tobin Bell. All rights reserved.
//

struct WPPostSubset: Hashable {
    
    static let All = WPPostSubset(categoryID: nil, tagID: nil)
    
    let categoryID: Int?
    let tagID: Int?
    
    var hashValue: Int {
        return (categoryID?.hashValue ?? 0) ^ (tagID?.hashValue ?? 0)
    }
}

func ==(a: WPPostSubset, b: WPPostSubset) -> Bool {
    return a.categoryID == b.categoryID &&
        a.tagID == b.tagID
}

