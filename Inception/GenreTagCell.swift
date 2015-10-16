//
//  GenreTagCell.swift
//  Inception
//
//  Created by David Ehlen on 16.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import SKTagView

class GenreTagCell: UITableViewCell {
    
    @IBOutlet weak var tagView : SKTagView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

