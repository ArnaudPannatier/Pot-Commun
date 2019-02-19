//
//  Mouvement+CoreDataProperties.swift
//  Pot Commun
//
//  Created by Arnaud Pannatier on 15.09.16.
//  Copyright © 2016 Arnaud Pannatier. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Mouvement {

    @NSManaged var valeur: NSNumber?
    @NSManaged var date: Date?
    @NSManaged var id: NSNumber?
    @NSManaged var coloc: String?

}
