//
//  ImageFadeAndLoadExtension.swift
//  Inception
//
//  Created by David Ehlen on 05.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

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
}