//
//  GenreTagCell.swift
//  Inception
//
//  Created by David Ehlen on 16.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import JCTagListView

class GenreTagCell: UITableViewCell {
    
    @IBOutlet weak var tagListView : JCTagListView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
