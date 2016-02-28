//
//  CategoryTableViewCell.swift
//  CNECT
//
//  Created by Tobin Bell on 2/27/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var imageOverlayView = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        imageOverlayView.frame = featuredImageView.bounds
        imageOverlayView.backgroundColor = UIColor(white: 0.3, alpha: 1.0)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = imageOverlayView.bounds
        gradientLayer.colors = [UIColor(white: 1.0, alpha: 0.0).CGColor, UIColor(white: 1.0, alpha: 0.5).CGColor]
        gradientLayer.startPoint = CGPointMake(1.0, 0.0)
        gradientLayer.endPoint = CGPointMake(0.0, 1.0)
        
        imageOverlayView.layer.mask = gradientLayer
        
        featuredImageView.addSubview(imageOverlayView)
        
        // Add drop shaodws to the labels.
        addDropShadowTo(nameLabel)
        addDropShadowTo(taglineLabel)
        addDropShadowTo(descriptionLabel)
    }
    
    private func addDropShadowTo(label: UILabel) {
        label.layer.shadowColor = UIColor.blackColor().CGColor
        label.layer.shadowOffset = CGSize(width: 5, height: 5)
        label.layer.shadowRadius = 3.0;
        label.layer.shadowOpacity = 1.0;
        label.layer.shouldRasterize = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        imageOverlayView.backgroundColor = selected ? UIColor(white: 0.8, alpha: 1.0) : UIColor(white: 0.3, alpha: 1.0)
    }

}
