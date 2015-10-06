//
//  Path.swift
//  Inception
//
//  Created by David Ehlen on 24.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

protocol APIRoute {
    var path : String { get }
    var GETParameters : [String:AnyObject] { get }

}