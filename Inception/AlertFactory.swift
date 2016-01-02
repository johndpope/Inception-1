//
//  AlertFactory.swift
//  Inception
//
//  Created by David Ehlen on 14.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class AlertFactory {
    class func showAlert(localizeTitleKey:String, localizeMessageKey:String, from:UIViewController) {
        let alertController = UIAlertController(title: localizeTitleKey.localized, message: localizeMessageKey.localized, preferredStyle:.Alert)
        let dismissAction = UIAlertAction(title: "OK", style: .Default) { (_) in
        }
        alertController.addAction(dismissAction)
        dispatch_async(dispatch_get_main_queue(), {
            if from.isViewLoaded() && from.view.window != nil {
                from.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }
}
