//
//  DiscoverViewController.swift
//  Inception
//
//  Created by David Ehlen on 25.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import UIKit

class DiscoverViewControler : UIViewController {
    
    @IBOutlet weak var popularViewContainer:UIView!
    @IBOutlet weak var genreViewContainer:UIView!
    @IBOutlet weak var topRatedViewContainner:UIView!
    @IBOutlet weak var inCinemaViewContainer:UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "discover".localized
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex) {
        case 0:
            self.genreViewContainer.hidden = true
            self.topRatedViewContainner.hidden = true
            self.inCinemaViewContainer.hidden = true
            self.popularViewContainer.hidden = false
        case 1:
            self.genreViewContainer.hidden = false
            self.topRatedViewContainner.hidden = true
            self.inCinemaViewContainer.hidden = true
            self.popularViewContainer.hidden = true
        case 2:
            self.genreViewContainer.hidden = true
            self.topRatedViewContainner.hidden = false
            self.inCinemaViewContainer.hidden = true
            self.popularViewContainer.hidden = true
        case 3:
            self.genreViewContainer.hidden = true
            self.topRatedViewContainner.hidden = true
            self.inCinemaViewContainer.hidden = false
            self.popularViewContainer.hidden = true
        default:
            break;
        }
    }

}