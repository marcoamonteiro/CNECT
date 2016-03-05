//
//  ArticleTableViewCell.swift
//  SidebarMenu
//
//  Created by Marco Monteiro on 2/13/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var categoryLabel: UILabel?
    @IBOutlet weak var featuredImageView: UIImageView?
    @IBOutlet weak var excerptLabel: UILabel?
    
    @IBOutlet weak var darkenView: UIView?
    @IBOutlet weak var blurView: UIVisualEffectView?
    
    
    @IBOutlet weak var topMargin: NSLayoutConstraint?
    @IBOutlet weak var bottomMargin: NSLayoutConstraint?
    @IBOutlet weak var fixedFromTop: NSLayoutConstraint?
    @IBOutlet weak var titleVerticallyCentered: NSLayoutConstraint?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add drop shadows to labels for readability.
        titleLabel?.addDropShadow()
        categoryLabel?.addDropShadow()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        
        // Manipulate drop shadows.
        if selected {
            titleLabel?.removeDropShadow()
            categoryLabel?.removeDropShadow()
        } else {
            titleLabel?.addDropShadow()
            categoryLabel?.addDropShadow()
        }
        
        UIView.animateWithDuration(0.25) {
            // Switch between darken filter and blur effect.
            if selected {
                self.featuredImageView?.alpha = 1.0
                self.blurView?.alpha = 1
                self.darkenView?.alpha = 0
                self.excerptLabel?.alpha = 1
                
                self.titleLabel?.textColor = UIColor.blackColor()
                self.categoryLabel?.textColor = UIColor.blackColor()
            } else {
                self.featuredImageView?.alpha = 0.6
                self.blurView?.alpha = 0
                self.darkenView?.alpha = 0.7
                self.excerptLabel?.alpha = 0
                
                self.titleLabel?.textColor = UIColor.whiteColor()
                self.categoryLabel?.textColor = UIColor.whiteColor()
            }
            
            // Propagate constraint updates.
            self.adjustConstraintsForSelected(selected)
            self.contentView.setNeedsUpdateConstraints()
            self.contentView.layoutIfNeeded()
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if selected {
            if highlighted {
                darkenView?.alpha = 0.1
            } else {
                darkenView?.alpha = 0.0
            }
        } else {
            if highlighted {
                darkenView?.alpha = 0.6
            } else {
                darkenView?.alpha = 0.7
            }
        }
    }
    
    func adjustConstraintsForSelected(selected: Bool) {
        if selected {
            topMargin?.constant = 8
            bottomMargin?.constant = 16
            
            // Release restrictions to allow to expand.
            self.fixedFromTop?.active = true
            self.titleVerticallyCentered?.active = false
        } else {
            topMargin?.constant = 0
            bottomMargin?.constant = 8
            
            // Engage constraints to homogonize height.
            self.fixedFromTop?.active = false
            self.titleVerticallyCentered?.active = true
        }
    }

}
