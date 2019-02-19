//
//  Mouvement.swift
//  Pot Commun
//
//  Created by Arnaud Pannatier on 15.09.16.
//  Copyright © 2016 Arnaud Pannatier. All rights reserved.
//

import Foundation
import CoreData

@objc(Mouvement)
class Mouvement: NSManagedObject {

    class func MouvementWithmouvInfo(_ newColoc: String, newCout: Double, newDate: Date, inManagedObjectContext context: NSManagedObjectContext) -> Mouvement?
    {
        if let mouv = NSEntityDescription.insertNewObject(forEntityName: "Mouvement", into: context) as? Mouvement{
            mouv.coloc = newColoc
            mouv.valeur = newCout as NSNumber?
            mouv.date = newDate
            mouv.id = 0
            return mouv
        }
        return nil
    
    }
    class func removeLastMouvementofColoc(_ delColoc: String, inManagedObjectContext context: NSManagedObjectContext){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mouvement")
        request.predicate = NSPredicate(format: "coloc = %@", delColoc)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 1
        do{
            let toDel = try context.fetch(request) as? [Mouvement]
            context.delete((toDel?.first)!)
            
        }catch{
            print("Erreur de délétion")
        }
    
    
    }
    
// Insert code here to add functionality to your managed object subclass

}
