//
//  String.swift
//  CNECT
//
//  Created by Tobin Bell on 2/27/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import Foundation

extension String {
    
    func rangeFrom(range : NSRange) -> Range<Index> {
        return Range<Index>(start: startIndex.advancedBy(range.location), end: startIndex.advancedBy(range.location + range.length))
    }
}