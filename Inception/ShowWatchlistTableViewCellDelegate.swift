//
//  ShowWatchlistTableViewCellDelegate.swift
//  Inception
//
//  Created by David Ehlen on 26.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import AIFlatSwitch

protocol ShowWatchlistTableViewCellDelegate {
    func didToggleSeenFromShowSwitch(sender:AIFlatSwitch)
}
