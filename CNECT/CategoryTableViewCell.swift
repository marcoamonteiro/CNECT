//
//  CategoryTableViewCell.swift
//  CNECT
//
//  Created by Tobin Bell on 2/27/16.
//  Copyright © 2016 Marco Monteiro. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    
    @IBOutlet weak var blurView: UIVisualEffectView?
    @IBOutlet weak var darkenView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        UIView.animateWithDuration(animated ? 0.75 : 0) {
            self.darkenView?.alpha = selected ? 0.2 : 0
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        UIView.animateWithDuration(animated ? 0.25 : 0) {
            self.darkenView?.alpha = highlighted ? 0.2 : 0
        }
    }

}
