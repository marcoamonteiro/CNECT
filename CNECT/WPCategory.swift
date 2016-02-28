//
//  WPCategory.swift
//  cnect
//
//  Created by Marco Monteiro on 2/21/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import Foundation

struct WPCategory {
    let ID: Int
    let name: String
    let count: Int
    let tagline: String
    let description: String
    let slug: String
    let parentID: Int?
    
    let featuredImageURL: NSURL
    var featuredImage: UIImage?
    
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
        
        do {
            let taglineRegex = try NSRegularExpression(pattern: "<h5 class=\"caption\">(.*)</h5>", options: [])
            let matches = taglineRegex.matchesInString(dictDescription, options: [], range: NSRange(location: 0, length: dictDescription.characters.count))
            
            // We only care about the first (hopefully there is only one at all)
            if let match = matches.first {
                
                // Get the subcapture range.
                let innerRange = match.rangeAtIndex(1)
                tagline = dictDescription.substringWithRange(dictDescription.rangeFrom(innerRange))
            } else {
                tagline = ""
            }
        } catch {
            tagline = ""
        }
        
        var descriptionBuilder = ""
        
        do {
            let descriptionRegex = try NSRegularExpression(pattern: "<h5 class=\"subcaption\">(.*)</h5>", options: [.DotMatchesLineSeparators])
            let matches = descriptionRegex.matchesInString(dictDescription, options: [], range: NSRange(location: 0, length: dictDescription.characters.count))
            
            // Loop over all matches to account for Ben's unelegance.
            for match in matches {
                // Get the subcapture range.
                let innerRange = match.rangeAtIndex(1)
                let innerMatch = dictDescription.substringWithRange(dictDescription.rangeFrom(innerRange))
                print(innerMatch)
                descriptionBuilder += innerMatch
            }
        } catch {}
        
        name = dictName
        count = dictCount
        slug = dictSlug
        description = descriptionBuilder
        parentID = dictParent != 0 ? dictParent : nil
        ID = dictID
        
        featuredImageURL = NSURL(string: "http://cnect.co/wp-content/uploads/2016/01/\(name).jpg")!
    }
}
