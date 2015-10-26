//
//  ShowWatchlistTableViewCell.swift
//  Inception
//
//  Created by David Ehlen on 25.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import AIFlatSwitch

class ShowWatchlistTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel:UILabel!
    @IBOutlet weak var yearLabel:UILabel!
    @IBOutlet weak var coverImageView:UIImageView!
    @IBOutlet weak var seenButton:AIFlatSwitch!
    @IBOutlet weak var progressBar:UIProgressView!
    
    var delegate:ShowWatchlistTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.progressBar.layer.masksToBounds = true
        self.progressBar.layer.cornerRadius = self.progressBar.bounds.size.height/2
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func toggleSeen(sender:AIFlatSwitch) {
        if let delegate = self.delegate {
            delegate.didToggleSeenFromShowSwitch(sender)
        }
    }
}
