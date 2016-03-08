//
//  TagCell.swift
//  CNECT
//
//  Created by Tobin Bell on 3/7/16.
//  Copyright © 2016 Tobin Bell. All rights reserved.
//

import UIKit

class TagCell: UITableViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var universityLabel: UILabel?
    
    @IBOutlet weak var darkenView: UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
