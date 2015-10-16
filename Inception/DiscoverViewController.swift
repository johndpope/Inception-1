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
            self.showViewContainer(true, topRatedHidden: true, inCinemaHidden: true, popularHidden: false)
        case 1:
            self.showViewContainer(false, topRatedHidden: true, inCinemaHidden: true, popularHidden: true)

        case 2:
            self.showViewContainer(true, topRatedHidden: false, inCinemaHidden: true, popularHidden: true)

        case 3:
            self.showViewContainer(true, topRatedHidden: true, inCinemaHidden: false, popularHidden: true)

        default:
            break;
        }
    }
    
    func showViewContainer(genreHidden:Bool, topRatedHidden:Bool, inCinemaHidden:Bool, popularHidden:Bool) {
        self.genreViewContainer.hidden = genreHidden
        self.topRatedViewContainner.hidden = topRatedHidden
        self.inCinemaViewContainer.hidden = inCinemaHidden
        self.popularViewContainer.hidden = popularHidden
    }

}