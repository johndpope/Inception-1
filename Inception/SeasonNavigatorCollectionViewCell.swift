//
//  SeasonNavigatorCollectionViewCell.swift
//  Inception
//
//  Created by David Ehlen on 21.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class SeasonNavigatorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var roundedView:UIView!
    @IBOutlet weak var titleLabel:UILabel!
    
    override func awakeFromNib() {
        self.roundedView.layer.cornerRadius = self.roundedView.frame.size.width/2
    }
}
