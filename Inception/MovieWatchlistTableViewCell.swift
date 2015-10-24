//
//  MovieWatchlistTableViewCell.swift
//  Inception
//
//  Created by David Ehlen on 24.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import AIFlatSwitch

class MovieWatchlistTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var yearLabel:UILabel!
    @IBOutlet weak var coverImageView:UIImageView!
    @IBOutlet weak var seenButton:AIFlatSwitch!
    
    var delegate:MovieWatchlistTableViewCellDelegate?
    
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
            delegate.didToggleSeenFromSwitch(sender)
        }
    }

}
