//
//  File.swift
//  Inception
//
//  Created by David Ehlen on 26.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import AIFlatSwitch

extension WatchlistViewController : ShowWatchlistTableViewCellDelegate {
    func didToggleSeenFromShowSwitch(sender: AIFlatSwitch) {
        let buttonFrame = sender.convertRect(sender.bounds, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonFrame.origin)
        if let indexPathUnwrapped = indexPath {
            let show = self.shows[indexPathUnwrapped.row]
            if let id = show.id {
                let seen = self.showCoreDataHelper.isShowSeen(show)
                self.showCoreDataHelper.updateShowSeenState(!Bool(seen), id:Int(id))
                self.tableView.reloadData()
            }
        }
    }
}
