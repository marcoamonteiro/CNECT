//
//  UITableViewController.swift
//  CNECT
//
//  Created by Tobin Bell on 3/3/16.
//  Copyright © 2016 Tobin Bell. All rights reserved.
//

import UIKit

extension UITableViewController {
    
    func addActivityIndicatorView() -> UIView {
        let background = UIView(frame: view.bounds)
        background.backgroundColor = UIColor.whiteColor()
        
        // Create a path to draw the ring with.
        let circlePathLayer = CAShapeLayer()
        circlePathLayer.frame = background.bounds
        circlePathLayer.lineWidth = 3
        circlePathLayer.fillColor = UIColor.clearColor().CGColor
        circlePathLayer.strokeColor = UIColor.darkThemeColor.CGColor
        circlePathLayer.path = circlePath(20.0, inView: background).CGPath
        
        background.layer.addSublayer(circlePathLayer)
        
        let circleIn = CABasicAnimation(keyPath: "strokeEnd")
        circleIn.fromValue = 0
        circleIn.toValue = 1
        circleIn.duration = 0.6
        
        let circleOut = CABasicAnimation(keyPath: "strokeStart")
        circleOut.fromValue = 0
        circleOut.toValue = 1
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [circleIn, circleOut]
        animationGroup.duration = 1.2
        animationGroup.repeatCount = HUGE
        
        circlePathLayer.addAnimation(animationGroup, forKey: "ringAnimation")
        
        view.addSubview(background)
        return background
    }
    
    private func circlePath(circleRadius: CGFloat, inView parent: UIView) -> UIBezierPath {
        return UIBezierPath(ovalInRect: circleFrame(circleRadius, inView: parent))
    }
    
    private func circleFrame(circleRadius: CGFloat, inView parent: UIView) -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
        circleFrame.origin.x = parent.bounds.midX - circleFrame.midX
        circleFrame.origin.y = 4 * parent.bounds.midY / 5 - circleFrame.midY
        return circleFrame
    }
    
}
