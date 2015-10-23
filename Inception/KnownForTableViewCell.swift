//
//  KnownForTableViewCell.swift
//  Inception
//
//  Created by David Ehlen on 23.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class KnownForTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel:UILabel!
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
