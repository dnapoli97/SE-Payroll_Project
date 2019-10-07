//
//  PersistentContainer.swift
//  Team 1 Payroll
//
//  Created by Dylan Napoli on 10/6/19.
//  Copyright © 2019 Dylan Napoli apps. All rights reserved.
//

import UIKit
import CoreData

class PersistentContainer: NSPersistentContainer {
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
    
}
