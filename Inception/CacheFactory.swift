//
//  CacheFactory.swift
//  Inception
//
//  Created by David Ehlen on 14.10.15.
//  Copyright © 2015 David Ehlen. All rights reserved.
//

import Foundation
import SDWebImage

class CacheFactory {
    
    class func clearAllCaches() {
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        SDImageCache.sharedImageCache().clearMemory()
        SDImageCache.sharedImageCache().clearDisk()
    }
    
    class func clearImageCache() {
        SDImageCache.sharedImageCache().clearMemory()
        SDImageCache.sharedImageCache().clearDisk()
    }
    
    class func clearRequestCache() {
        NSURLCache.sharedURLCache().removeAllCachedResponses()
    }
    
    class func setMaxImageCacheSize(size:UInt) {
        SDImageCache.sharedImageCache().maxCacheSize = size
    }
    
    class func imageCacheDescription() -> String {
       return NSString(format: "%.2f MB / %.2f MB", Double(SDImageCache.sharedImageCache().getSize())/1024.0/1024.0 ,Double(SDImageCache.sharedImageCache().maxCacheSize)/1024.0/1024.0) as String
    }
    
    class func cacheDescription() -> String {
       return NSString(format: "%.2f MB / %.2f MB", Double(NSURLCache.sharedURLCache().currentDiskUsage)/1024.0/1024.0 ,Double(NSURLCache.sharedURLCache().diskCapacity)/1024.0/1024.0) as String
    }
    
}