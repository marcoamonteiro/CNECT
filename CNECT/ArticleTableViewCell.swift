//
//  ArticleTableViewCell.swift
//  SidebarMenu
//
//  Created by Marco Monteiro on 2/13/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let darkView = UIView(frame: featuredImageView.bounds)
        darkView.backgroundColor = UIColor.blackColor()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = darkView.bounds
        
        gradientLayer.colors = [UIColor(white: 1.0, alpha: 0.0).CGColor, UIColor(white: 1.0, alpha: 0.6).CGColor]
        gradientLayer.startPoint = CGPointMake(1.0, 0.0)
        gradientLayer.endPoint = CGPointMake(0.0, 0.0)
        darkView.layer.mask = gradientLayer
        
        featuredImageView.addSubview(darkView)
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        if selected {
//            filter.backgroundColor = UIColor.blackColor()
//            filter.alpha = 0.8
//        }
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//    override func setHighlighted(highlighted: Bool, animated: Bool) {
//        if highlighted {
//            filter.backgroundColor = UIColor.blackColor()
//            filter.alpha = 0.8
//        }
//
//        super.setHighlighted(highlighted, animated: animated)
//    }

}
