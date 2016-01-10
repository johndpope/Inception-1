//
//  PersonWatchlistCoreDataHelper.swift
//  Inception
//
//  Created by David Ehlen on 06.01.16.
//  Copyright © 2016 David Ehlen. All rights reserved.
//

import UIKit
import CoreData

class PersonWatchlistCoreDataHelper {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let kPersonWatchlistItemEntityName = "PersonWatchlistItem"
    let kPersonCreditEntityName = "PersonCredit"
    
    func personsFromStore() -> [PersonWatchlistItem] {
        let fetchRequest = NSFetchRequest(entityName: kPersonWatchlistItemEntityName)
        var persons:[PersonWatchlistItem] = []
        do {
            persons = try self.managedObjectContext.executeFetchRequest(fetchRequest) as! [PersonWatchlistItem]
            persons.sortInPlace(nameFilter)
            return persons
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        return persons
    }
    
    func nameFilter(this:PersonWatchlistItem, that:PersonWatchlistItem) -> Bool {
        if let thisName = this.name {
            if let thatName = that.name {
                return thisName < thatName
            }
        }
        return false
    }
    
    func insertPersonItem(id:Int, name:String?, profilePath:String?, credits:[MultiSearchResult]) {
        if hasPerson(id) {
            return
        }
        
        let newEntity = NSEntityDescription.insertNewObjectForEntityForName(kPersonWatchlistItemEntityName, inManagedObjectContext: self.managedObjectContext) as! PersonWatchlistItem
        newEntity.id = id
        newEntity.name = name
        newEntity.profilePath = profilePath
        
        if credits.count != 0 {
            var watchlistPersonCredits:[PersonCredit] = []
            for element:MultiSearchResult in credits {
                if let id = element.id {
                    let personCredit = NSEntityDescription.insertNewObjectForEntityForName(self.kPersonCreditEntityName, inManagedObjectContext: self.managedObjectContext) as! PersonCredit
                    personCredit.name = element.name
                    personCredit.id = NSNumber(integer:id)
                    personCredit.imagePath = element.imagePath
                    personCredit.releaseDate = element.releaseDate?.date
                    personCredit.mediaType = element.mediaType
                    personCredit.person = newEntity
                    watchlistPersonCredits.append(personCredit)
                }
            }
            
            newEntity.lastUpdated = NSDate()
            newEntity.credits = NSSet(array:watchlistPersonCredits)
            (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
            NSNotificationCenter.defaultCenter().postNotificationName("personCreditsDidLoad", object: nil, userInfo: nil)
        }
        else {
            self.loadCredits(id,watchlistPerson:newEntity) {(loadedCredits:[PersonCredit]) in
                newEntity.credits = NSSet(array:loadedCredits)
                newEntity.lastUpdated = NSDate()
                (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
                NSNotificationCenter.defaultCenter().postNotificationName("personCreditsDidLoad", object: nil, userInfo: nil)
            }
        }
    }
    
    func loadCredits(id:Int,watchlistPerson:PersonWatchlistItem,completionClosure:[PersonCredit] -> ()) {
        APIController.request(APIEndpoints.PersonCredits(id)) { (data:AnyObject?, error:NSError?) in
            if (error != nil) {
                print(error)
                completionClosure([])
            } else {
                
                let knownFor = JSONParser.parseCombinedCredits(data)
                var watchlistPersonCredits:[PersonCredit] = []
                for element:MultiSearchResult in knownFor {
                    if let id = element.id {
                        let personCredit = NSEntityDescription.insertNewObjectForEntityForName(self.kPersonCreditEntityName, inManagedObjectContext: self.managedObjectContext) as! PersonCredit
                        personCredit.name = element.name
                        personCredit.id = NSNumber(integer:id)
                        personCredit.imagePath = element.imagePath
                        personCredit.releaseDate = element.releaseDate?.date
                        personCredit.mediaType = element.mediaType
                        personCredit.person = watchlistPerson
                        watchlistPersonCredits.append(personCredit)
                    }
                }
                completionClosure(watchlistPersonCredits)
            }
        }
    }
    
    func removePerson(person:PersonWatchlistItem) {
        self.managedObjectContext.deleteObject(person)
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
    }
    
    func removePersonWithId(id:Int) {
        if let person = self.personWithId(id) {
            self.removePerson(person)
        }
    }
    
    func hasPerson(id:Int) -> Bool {
        return self.personWithId(id) != nil
    }
    
    func personWithId(id:Int) -> PersonWatchlistItem? {
        let fetchRequest = NSFetchRequest(entityName: kPersonWatchlistItemEntityName)
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)
        
        do {
            if let fetchResults = try self.managedObjectContext.executeFetchRequest(fetchRequest) as?[PersonWatchlistItem] {
                if fetchResults.count != 0 {
                    return fetchResults[0]
                }
            }
        } catch let error as NSError {
            print("Fetch failed: \(error.localizedDescription)")
        }
        return nil
    }
}
