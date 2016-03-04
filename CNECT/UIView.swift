//
//  UIView.swift
//  CNECT
//
//  Created by Tobin Bell on 3/2/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import UIKit

extension UIView {
    
    func addDropShadow(radius: Float = 16, opacity: Float = 1) {
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = CGFloat(radius)
        layer.shadowOpacity = opacity
        layer.shouldRasterize = true
    }
    
    func removeDropShadow() {
        layer.shadowOpacity = 0.0
    }
    
    var rendered: UIImage {
        get {
            UIGraphicsBeginImageContextWithOptions(bounds.size, opaque, 0.0)
            if let context = UIGraphicsGetCurrentContext() {
                layer.renderInContext(context)
            }
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return image
        }
    }
    
}