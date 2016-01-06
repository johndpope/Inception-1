//
//  PersonDetailWatchlistTableViewCell.swift
//  Inception
//
//  Created by David Ehlen on 06.01.16.
//  Copyright © 2016 David Ehlen. All rights reserved.
//

import UIKit

class PersonDetailWatchlistTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var yearLabel:UILabel!
    @IBOutlet weak var coverImageView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

