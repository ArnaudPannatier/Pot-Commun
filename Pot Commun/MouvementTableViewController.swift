//
//  MouvementTableViewController.swift
//  Pot Commun
//
//  Created by Arnaud Pannatier on 15.09.16.
//  Copyright © 2016 Arnaud Pannatier. All rights reserved.
//

import UIKit
import CoreData

class MouvementTableViewController: CoreDataTableViewController {
    // MARK: MODEL
    var managedObjectContext: NSManagedObjectContext? {
        didSet {
            updateUI()
        }
    }
    fileprivate func updateUI() {

        if let context = managedObjectContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Mouvement")
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        managedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MouvementCell", for: indexPath)

        if let mouvement = fetchedResultsController?.object(at: indexPath) as? Mouvement {
            var cellText: String?
            var detailText: String?

            mouvement.managedObjectContext?.performAndWait {
                let dateform = DateFormatter()
                dateform.dateFormat = "dd MMMM YYYY"
                dateform.locale = Locale(identifier: "fr_FR")
                detailText = mouvement.valeur!.stringValue + " francs - " + dateform.string(from: mouvement.date!)
                cellText = String(mouvement.coloc!)

            }
            cell.textLabel?.text = cellText!
            cell.detailTextLabel?.text = detailText!
        }

        return cell
    }
}
