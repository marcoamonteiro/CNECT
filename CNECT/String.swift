//
//  String.swift
//  CNECT
//
//  Created by Tobin Bell on 2/27/16.
//  Copyright © 2016 Tobin Bell. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func rangeFrom(range : NSRange) -> Range<Index> {
        return Range<Index>(start: startIndex.advancedBy(range.location), end: startIndex.advancedBy(range.location + range.length))
    }
    
    var attributedString: NSAttributedString? {
        // Decode the HTML entitities embedded in the titles.
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let attributedOptions: [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute:        NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute:   NSUTF8StringEncoding
        ]
        
        do {
            let attributedString = try NSAttributedString(data: data, options: attributedOptions, documentAttributes: nil)
            return attributedString
        } catch {
            return nil
        }
    }
    
    var plainString: String? {
        return attributedString?.string
    }
}