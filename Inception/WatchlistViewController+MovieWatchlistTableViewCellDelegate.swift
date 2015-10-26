//
//  WatchlistViewController+MovieWatchlistTableViewCellDelegate.swift
//  Inception
//
//  Created by David Ehlen on 24.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import AIFlatSwitch

extension WatchlistViewController : MovieWatchlistTableViewCellDelegate {
    func didToggleSeenFromSwitch(sender: AIFlatSwitch) {
        let buttonFrame = sender.convertRect(sender.bounds, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(buttonFrame.origin)
        if let indexPathUnwrapped = indexPath {
            let movie = self.movies[indexPathUnwrapped.row]
            if let id = movie.id {
                if let seen = movie.seen {
                    self.coreDataHelper.updateMovieSeenState(!Bool(seen), id:Int(id))
                }
                else {
                    self.coreDataHelper.updateMovieSeenState(true, id: Int(id))
                }
                self.tableView.reloadData()
            }
        }
    }
}
