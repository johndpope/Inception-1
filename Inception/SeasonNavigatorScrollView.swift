//
//  SeasonNavigatorScrollView.swift
//  Inception
//
//  Created by David Ehlen on 20.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class SeasonNavigatorScrollView: UIScrollView {
    private let kButtonSize:CGFloat = 50.0
    private let kSpacing:CGFloat = 10.0
    private var buttons:[UIButton] = []
    var seasonNavigatorDelegate:SeasonNavigatorDelegate?
    
    func setup(count:Int) {
        self.contentSize = CGSizeMake((kButtonSize+kSpacing)*CGFloat(count), self.bounds.size.height)
        for i in 0..<count {
            let button = UIButton(type: .Custom)
            button.setTitle("\(i+1)", forState:.Normal)
            button.frame = CGRectMake(CGFloat(i)*kButtonSize+kSpacing, (self.bounds.height-kButtonSize)/2, kButtonSize, kButtonSize)
            button.setTitleColor(.whiteColor(), forState: .Normal)
            button.tag = i
            button.layer.cornerRadius = kButtonSize/2
            button.backgroundColor = UIColor.clearColor()
            button.addTarget(self, action: "didClickSeason:", forControlEvents: .TouchUpInside)
            buttons.append(button)
            self.addSubview(button)
        }
    }
    
    func didClickSeason(sender:UIButton) {
        self.animateButtonSelection(sender)
        self.seasonNavigatorDelegate?.didClickIndex(sender.tag)
    }
    
    func animateButtonSelection(sender:UIButton) {
        for button in buttons {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                button.backgroundColor = UIColor.clearColor()
                }, completion: nil)
        }
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            sender.backgroundColor = UIColor(red:1.0,green:222.0/255.0,blue:96.0/255.0, alpha:1.0)
            }, completion: nil)
    }

}
