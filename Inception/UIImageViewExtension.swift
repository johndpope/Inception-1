//
//  ImageFadeAndLoadExtension.swift
//  Inception
//
//  Created by David Ehlen on 05.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func loadAndFade(imageURL:NSURL,placeholderImage:String) {
        self.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: placeholderImage), completed: {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
            if cacheType == SDImageCacheType.None {
                self.alpha = 0.0
                UIView.animateWithDuration(1.0, animations: {
                    self.alpha = 1.0
                })
            }
            else {
                self.alpha = 1.0
            }
        })
    }
    
    func loadAndFadeWithImage(imageURL:NSURL,placeholderImage:UIImage) {
        self.sd_setImageWithURL(imageURL, placeholderImage: placeholderImage, completed: {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
            if cacheType == SDImageCacheType.None {
                self.alpha = 0.0
                UIView.animateWithDuration(1.0, animations: {
                    self.alpha = 1.0
                })
            }
            else {
                self.alpha = 1.0
            }
        })
    }

    
    func imageWithString(string:String, color:UIColor, circular:Bool) -> UIImage {
        let kFontResizingProportion:CGFloat = 0.42
        let fontSize:CGFloat = CGRectGetWidth(self.bounds) * kFontResizingProportion
        let textAttributes:[String:AnyObject]? = [NSFontAttributeName: UIFont.systemFontOfSize(fontSize), NSForegroundColorAttributeName: UIColor.whiteColor()]
        let displayString:NSMutableString = ""
        var words = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if words.count > 0 {
            let firstWord:NSString = words.first!
            if firstWord.length > 0 {
                let firstLetterRange = firstWord.rangeOfComposedCharacterSequencesForRange(NSMakeRange(0,1))
                displayString.appendString(firstWord.substringWithRange(firstLetterRange))
            }
            if words.count >= 2 {
                var lastWord:NSString = words.last!
                while lastWord.length == 0 && words.count >= 2 {
                    words.removeLast()
                    lastWord = words.last!
                }
                if words.count > 1 {
                    let lastLetterRange = lastWord.rangeOfComposedCharacterSequencesForRange(NSMakeRange(0, 1))
                    displayString.appendString(lastWord.substringWithRange(lastLetterRange))
                }
            }
        }
        return self.imageSnapshotFromText(displayString.uppercaseString, backgroundColor:color, circular:circular, textAttributes:textAttributes)
    }
    
    func imageSnapshotFromText(text:String, backgroundColor:UIColor, circular:Bool, textAttributes:[String:AnyObject]?) -> UIImage {
        let scale:CGFloat = UIScreen.mainScreen().scale
        var size = self.bounds.size

        if self.contentMode == .ScaleToFill ||
            self.contentMode == .ScaleAspectFill ||
            self.contentMode == .ScaleAspectFit ||
            self.contentMode == .Redraw {
                size.width = CGFloat(floorf(Float(size.width * scale)) / Float(scale))
                size.height = CGFloat(floorf(Float(size.height * scale)) / Float(scale))
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        if circular {
            let path = CGPathCreateWithEllipseInRect(self.bounds, nil)
            CGContextAddPath(context, path)
            CGContextClip(context)
        }
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor)
        CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height))
        
        let textSize = (text as NSString).sizeWithAttributes(textAttributes)
        let bounds = self.bounds
        (text as NSString).drawInRect(CGRectMake(bounds.size.width/2 - textSize.width/2, bounds.size.height/2 - textSize.height/2, textSize.width, textSize.height), withAttributes: textAttributes)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return snapshot
    }
}