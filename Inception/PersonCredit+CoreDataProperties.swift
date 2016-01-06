//
//  PersonCredit+CoreDataProperties.swift
//  
//
//  Created by David Ehlen on 06.01.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PersonCredit {

    @NSManaged var id: NSNumber
    @NSManaged var imagePath: String?
    @NSManaged var year: NSNumber?
    @NSManaged var mediaType: String?
    @NSManaged var name: String?
    @NSManaged var person: NSManagedObject?

}
