//
//  PersonDetailTableViewCell.swift
//  Inception
//
//  Created by David Ehlen on 27.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class PersonDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var textLbl: UILabel!
    @IBOutlet weak var detailTextLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}