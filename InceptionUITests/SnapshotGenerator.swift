//
//  SnapshotGenerator.swift
//  Inception
//
//  Created by David Ehlen on 04.11.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import XCTest

class SnapshotGenerator : XCTestCase {
    
    override func setUp() {
        super.setUp()
        let app = XCUIApplication()
        setLanguage(app)
        app.launch()
    }
    
    func testExample()
    {
        snapshot("0Launch")
        let tabBar = XCUIApplication().tabBars
        let secondButton = tabBar.buttons.elementBoundByIndex(1)
        let thirdButton = tabBar.buttons.elementBoundByIndex(2)
        let fourthButton = tabBar.buttons.elementBoundByIndex(3)
        let fifthButton = tabBar.buttons.elementBoundByIndex(4)

        XCUIDevice().orientation = UIDeviceOrientation.Portrait
        snapshot("SearchPortrait")
        
        secondButton.tap()
        XCUIDevice().orientation = UIDeviceOrientation.Portrait
        snapshot("DiscoverPortrait")
        
        thirdButton.tap()
        XCUIDevice().orientation = UIDeviceOrientation.Portrait
        snapshot("WatchlistPortrait")
        
        fourthButton.tap()
        XCUIDevice().orientation = UIDeviceOrientation.Portrait
        snapshot("StatsPortrait")
        
        fifthButton.tap()
        XCUIDevice().orientation = UIDeviceOrientation.Portrait
        snapshot("SettingsPortrait")
    }
    
    override func tearDown() {
        super.tearDown()
    }
}