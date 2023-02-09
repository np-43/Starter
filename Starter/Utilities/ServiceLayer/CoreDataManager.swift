//
//  CoreDataManager.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import CoreData
import ObjectMapper

class CoreDataManager: NSObject {
    
    static let shared: CoreDataManager = {
        let instance = CoreDataManager.init()
        return instance
    }()
    
    typealias CoreDataOperationCompletion = ((Bool, String, Any?) -> ())
    
    let managedObjContext: NSManagedObjectContext
//    let managedObjContextBG: NSManagedObjectContext
    
    fileprivate override init() {
        self.managedObjContext = AppConstant.appDelegate.persistentContainer.viewContext
        self.managedObjContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
//        self.managedObjContextBG = AppConstant.appDelegate.persistentContainer.newBackgroundContext()
//        self.managedObjContextBG.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
//        self.managedObjContextBG.parent = self.managedObjContext
    }
    
    func resetAllData() {
        // Below code will delete following files to reset/clear whole database.
        guard let url = AppConstant.appDelegate.persistentContainer.persistentStoreDescriptions.first?.url else { return }
        let persistentStoreCoordinator = AppConstant.appDelegate.persistentContainer.persistentStoreCoordinator
        do {
            try persistentStoreCoordinator.destroyPersistentStore(at:url, ofType: NSSQLiteStoreType, options: nil)
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            print("Attempted to clear persistent store: " + error.localizedDescription)
        }
    }
    
}
