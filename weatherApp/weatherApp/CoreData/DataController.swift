//
//  DataController.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import CoreData
import UIKit

/// Helps to get NSPersistentContainer
class DataController {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "weatherApp")
        return container
    }()
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return context
    }()

    init(completionClosure: @escaping () -> Void) {
        self.persistentContainer.loadPersistentStores { desc, error in
            if let err = error {
                fatalError("Error loading store \(desc): \(err)")
            } else {
                completionClosure()
            }
        }
    }
}

