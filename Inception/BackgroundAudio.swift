//
//  BackgroundAudio.swift
//  Inception
//
//  Created by David Ehlen on 29.12.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import AVFoundation

class BackgroundAudio {
    
    class func setPlaybackCategory() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        }
        catch {
            print("Audio session setCategory failed")
        }
    }
}