//
//  MovieDetailTableViewController+PiP.swift
//  Inception
//
//  Created by David Ehlen on 29.12.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import AVKit

extension MovieDetailTableViewController : AVPlayerViewControllerDelegate {
    func playerViewController(playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: (Bool) -> Void) {
        
        if self.isViewLoaded() && self.view.window != nil {
            self.presentViewController(playerViewController, animated: true, completion:nil)
        }
        
        let isPaused = playerViewController.player?.rate == 0.0
        if isPaused {
            playerViewController.player?.pause()
        }
        
        completionHandler(true)
    }
    
    func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(playerViewController: AVPlayerViewController) -> Bool {
        return false
    }
}