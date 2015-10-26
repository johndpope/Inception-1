//
//  WatchlistTableViewCellDelegate.swift
//  Inception
//
//  Created by David Ehlen on 24.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import AIFlatSwitch

protocol MovieWatchlistTableViewCellDelegate {
    func didToggleSeenFromSwitch(sender:AIFlatSwitch)
}