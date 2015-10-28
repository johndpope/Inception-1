//
//  TrailerFunctions.swift
//  Inception
//
//  Created by David Ehlen on 20.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit
import AVKit
import XCDYouTubeKit

class TrailerFunctions {
    class func playVideoWithIdentifier(identifier:String, from:UIViewController) {
        let playerViewController = AVPlayerViewController()
        playerViewController.showsPlaybackControls = false
        from.presentViewController(playerViewController, animated: true, completion: nil)
        
        XCDYouTubeClient.defaultClient().getVideoWithIdentifier(identifier) { [weak playerViewController] (video: XCDYouTubeVideo?, error: NSError?) in
            let videoURL = TrailerFunctions.streamURL(video)
            if videoURL != nil {
                print(videoURL)
                playerViewController?.player = AVPlayer(URL: videoURL!)
                playerViewController?.showsPlaybackControls = true
                playerViewController?.player?.play()

            }
            else {
                from.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    
    private class func streamURL(video:XCDYouTubeVideo?) -> NSURL?{
        var url:NSURL?
        let videoQualityString = SettingsFactory.objectForKey(SettingsFactory.SettingKey.VideoQuality) as! String
        if let videoQuality = SettingsFactory.VideoQuality(rawValue: videoQualityString) {
            switch videoQuality {
                case .HD : url = video?.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] as? NSURL
                case .Medium: url = video?.streamURLs[XCDYouTubeVideoQuality.Medium360.rawValue] as? NSURL
                case .Small: url = video?.streamURLs[XCDYouTubeVideoQuality.Small240.rawValue] as? NSURL
            }
        }
        if url == nil {
            if let streamURL = video?.streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] as? NSURL ??
                video?.streamURLs[XCDYouTubeVideoQuality.HD720.rawValue] as? NSURL ??
                video?.streamURLs[XCDYouTubeVideoQuality.Medium360.rawValue] as? NSURL ??
                video?.streamURLs[XCDYouTubeVideoQuality.Small240.rawValue] as? NSURL {
                    url = streamURL
            }
        }
        return url
    }
    
    class func showTrailerActionSheet(videos:[Video], from:UIViewController) {
        let actionSheetController = DOAlertController(title: "trailer".localized, message: "chooseTrailer".localized, preferredStyle: .ActionSheet)
        
        actionSheetController.alertViewBgColor = UIColor.darkTextColor()
        actionSheetController.buttonTextColor[.Default] = UIColor(red:1.0, green:222.0/255.0, blue:96.0/255.0, alpha:1.0)
        actionSheetController.buttonBgColor[.Default] = UIColor.clearColor()
        actionSheetController.buttonBgColorHighlighted[.Default] = UIColor.clearColor()
        actionSheetController.buttonBgColor[.Cancel] = UIColor.clearColor()
        actionSheetController.buttonBgColorHighlighted[.Cancel] = UIColor.clearColor()
        
        let cancelAction = DOAlertAction(title: "cancel".localized, style: .Cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelAction)
        
        for video in videos {
            if let name = video.name {
                if let key = video.key {
                    let trailerAction = DOAlertAction(title: name, style: .Default) { action -> Void in
                        TrailerFunctions.playVideoWithIdentifier(key,from:from)
                    }
                    actionSheetController.addAction(trailerAction)
                }
            }
        }
        
        
        from.presentViewController(actionSheetController, animated: true, completion: nil)
    }
}
