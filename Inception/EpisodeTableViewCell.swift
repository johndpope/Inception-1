//
//  EpisodeTableViewCell.swift
//  Inception
//
//  Created by David Ehlen on 21.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var votingLabel:UILabel!
    @IBOutlet weak var overviewLabel:UILabel!
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
