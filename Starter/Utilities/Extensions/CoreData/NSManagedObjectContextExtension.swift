//
//  NSManagedObjectContextExtension.swift
//  Starter
//
//  Created by Nikhil Patel on 09/02/23.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func insert(intoEntity entity: String) -> NSManagedObject {
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: entity, into: self)
        return managedObject
    }
    
    func insert(intoEntity entity: String, condition:String, _ args: CVarArg...) -> NSManagedObject {
        let array = self.getData(forEntity: entity, condition: condition, args: args)
        let managedObject = array.first ?? self.insert(intoEntity: entity)
        return managedObject
    }
    
    func getAllData(forEntity entity: String) -> [NSManagedObject] {
        let array = self.getData(forEntity: entity, condition: "")
        return array
    }
    
    func getData(forEntity entity: String, condition:String, _ args: CVarArg...) -> [NSManagedObject] {
        let array = self.getData(forEntity: entity, condition: condition, args: args)
        return array
    }
    
    fileprivate func getData(forEntity entity: String, condition:String, args: [CVarArg]) -> [NSManagedObject] {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.entity = entityDescription
        
        if condition.count > 0 {
            let predicate = NSPredicate.init(format: condition, arguments: getVaList(args))
            fetchRequest.predicate = predicate
        }
        
        var array = [NSManagedObject].init()
        do {
            array = try self.fetch(fetchRequest) as? [NSManagedObject] ?? []
        } catch {
            print(error)
        }
        
        return array
        
    }
    
    func getData(forEntity entity: String, fields: [String] = [], condition:String, _ args: CVarArg...) -> [[String: Any]] {
        let array = self.getData(forEntity: entity, fields: fields, condition: condition, args: args)
        return array
    }
    
    fileprivate func getData(forEntity entity: String, fields: [String] = [], condition:String, args: [CVarArg]) -> [[String: Any]] {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: self)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.entity = entityDescription
        
        fetchRequest.resultType = .dictionaryResultType
        if fields.count > 0 {
            fetchRequest.propertiesToFetch = fields
        }
        
        if condition.count > 0 {
            let predicate = NSPredicate.init(format: condition, arguments: getVaList(args))
            fetchRequest.predicate = predicate
        }
        
        var array = [[String: Any]].init()
        do {
            array = try self.fetch(fetchRequest) as? [[String: Any]] ?? []
        } catch {
            print(error)
        }
        
        return array
        
    }
    
    func deleteAllData(forEntity entity: String, _ completion: ((Bool, String)->())? = nil) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: entity)
        let batchDeleteRequest = NSBatchDeleteRequest.init(fetchRequest: fetchRequest)
        do {
            let _ = try self.execute(batchDeleteRequest)
            self.commit(completion)
        } catch {
            completion?(false, error.localizedDescription)
        }
        
    }
    
    func deleteData(forEntity entity: String, condition: String, _ args: CVarArg..., completion: ((Bool, String)->())? = nil) {
        let array = self.getData(forEntity: entity, condition: condition, args: args)
        for managedObject in array {
            self.delete(managedObject)
        }
        self.commit(completion)
    }
    
    func commit(_ completion: ((Bool, String)->())? = nil) {
        do {
            try self.save()
            completion?(true, "")
            return
        } catch {
            print("\n******************* Core Data Error *******************\n", error, "\n*******************************************************\n")
            completion?(false, error.localizedDescription)
            return
        }
    }
    
}
