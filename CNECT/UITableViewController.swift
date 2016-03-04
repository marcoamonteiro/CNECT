//
//  UITableViewController.swift
//  CNECT
//
//  Created by Tobin Bell on 3/3/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import UIKit

extension UITableViewController {
    
    func addActivityIndicatorView() -> UIActivityIndicatorView {
        let width: CGFloat = 24
        let height: CGFloat = 24
        let x = (view.frame.width - width) / 2
        let y = (view.frame.height - height) / 2
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.frame = CGRect(x: x, y: y, width: width, height: height)
        
        view.addSubview(indicator)
        indicator.startAnimating()
        return indicator
    }
    
}
