//
//  UINavigationBar.swift
//  CNECT
//
//  Created by Tobin Bell on 3/2/16.
//  Copyright © 2016 Tobin Bell. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    // So we can access it nicely from elsewhere.
    var borderView: UIImageView? {
        get {
            return findBottomBorderFor(self)
        }
    }
    
    // Search subviews for a UIImageView whose height is 1 or less.
    private func findBottomBorderFor(view: UIView) -> UIImageView? {
        if view.bounds.height <= 1,
            let view = view as? UIImageView {
            return view
        }
        
        for subview in view.subviews {
            if let borderView = findBottomBorderFor(subview) {
                return borderView
            }
        }
        
        return nil
    }
    
}

