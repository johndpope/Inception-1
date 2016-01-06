//
//  PersonUpdater.swift
//  Inception
//
//  Created by David Ehlen on 06.01.16.
//  Copyright © 2016 David Ehlen. All rights reserved.
//

import Foundation
import SwiftyJSON

class PersonUpdater {
    
    let personCoreDataHelper = PersonWatchlistCoreDataHelper()
    var asyncOperations:Int = 0
    var delegate:PersonUpdaterDelegate?
    
    func updateFrom(viewController:UIViewController) {
        let personArray = personCoreDataHelper.personsFromStore()
        var hasToUpdate = false
        
        for person in personArray {
            if !person.lastUpdated.isToday {
                hasToUpdate = true
            }
        }
        
        if !hasToUpdate {
            return
        }
        
        for i in 0..<personArray.count {
            let person = personArray[i]
            if person.lastUpdated.isToday {
                continue
            }
            
            self.asyncOperations+=1
            personCoreDataHelper.loadCredits(person.id.integerValue,watchlistPerson:person) { (credits:[PersonCredit]) in
                person.credits = NSOrderedSet(array: credits)
                (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
                if self.asyncOperations == 0 {
                    if let delegate = self.delegate {
                        delegate.didUpdatePersons()
                    }
                }
            }
        }
    }
}
