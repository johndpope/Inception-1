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
        XCUIDevice().orientation = UIDeviceOrientation.Portrait
        let tabBar = XCUIApplication().tabBars
        tabBar.buttons.elementBoundByIndex(0).tap()
        snapshot("SearchPortrait")
        
        tabBar.buttons.elementBoundByIndex(1).tap()
        snapshot("DiscoverPortrait")
        
        tabBar.buttons.elementBoundByIndex(2).tap()
        snapshot("WatchlistPortrait")
        
        tabBar.buttons.elementBoundByIndex(3).tap()
        snapshot("StatsPortrait")
        
        tabBar.buttons.elementBoundByIndex(4).tap()
        snapshot("SettingsPortrait")
    }
    
    override func tearDown() {
        super.tearDown()
    }
}