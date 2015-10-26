//
//  EpisodeWatchlistTableViewCell.swift
//  Inception
//
//  Created by David Ehlen on 26.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import AIFlatSwitch

class EpisodeWatchlistTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var overviewLabel:UILabel!
    @IBOutlet weak var coverImageView:UIImageView!
    @IBOutlet weak var seenButton:AIFlatSwitch!

    var delegate:EpisodeWatchlistTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func toggleSeen(sender:AIFlatSwitch) {
        if let delegate = self.delegate {
            delegate.didToggleSeenFromEpisodeSwitch(sender)
        }
    }
}