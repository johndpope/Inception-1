//
//  APIController.swift
//  Inception
//
//  Created by David Ehlen on 24.09.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import Alamofire

class APIController {
    
    typealias APIResponse = (AnyObject?,NSError?) -> Void
    
    class func request(endpoint:APIEndpoints, onCompletion:(APIResponse)) -> Void {
        let url = baseURL.URLByAppendingPathComponent(endpoint.path)
        Alamofire.request(.GET, url,parameters: endpoint.GETParameters).responseJSON { (request, response, result) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            switch result {
                case .Success(let JSON):
                    onCompletion(JSON,nil)
                
                case .Failure(let data, let error):
                    onCompletion(data,error as NSError)
            }
        }
    }
}