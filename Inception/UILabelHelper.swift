//
//  UILabel+Height.swift
//  Inception
//
//  Created by David Ehlen on 22.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
class UILabelHelper {
    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}