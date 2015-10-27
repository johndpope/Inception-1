//
//  StatsTableViewCell.swift
//  Inception
//
//  Created by David Ehlen on 27.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var keyLabel:UILabel!
    @IBOutlet weak var valueLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
