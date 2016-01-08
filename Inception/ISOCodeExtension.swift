//
//  ISOCodeExtension.swift
//  Inception
//
//  Created by David Ehlen on 08.01.16.
//  Copyright © 2016 David Ehlen. All rights reserved.
//

import Foundation

extension String {
    var countryNameFromCode:String {
        let locale = NSLocale(localeIdentifier:self)
        let countryName = locale.displayNameForKey(NSLocaleCountryCode, value: self)
        return countryName!
    }
}