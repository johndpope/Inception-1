//
//  CreditsCollectionCell.swift
//  Inception
//
//  Created by David Ehlen on 27.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class CreditsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var coverImageView:UIImageView!
    @IBOutlet weak var textLabel:UILabel!
    @IBOutlet weak var detailTextLabel:UILabel!

    override func awakeFromNib() {
        self.coverImageView.layer.borderWidth = 1.0
        
        self.coverImageView.layer.borderColor = ThemeManager.sharedInstance.currentTheme.tableViewSelectionColor.CGColor
        self.coverImageView.layer.cornerRadius = self.coverImageView.frame.size.width / 2
        self.coverImageView.clipsToBounds = true
    }
}
