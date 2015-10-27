//
//  UpcomingEpisodesTableViewCell.swift
//  Inception
//
//  Created by David Ehlen on 27.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class UpcomingEpisodesTableViewCell: UITableViewCell {

    @IBOutlet weak var episodeNameLabel:UILabel!
    @IBOutlet weak var showNameLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
