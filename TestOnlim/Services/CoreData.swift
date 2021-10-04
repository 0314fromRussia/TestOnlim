//
//  CoreData.swift
//  TestOnlim
//
//  Created by Никита Дмитриев on 04.10.2021.
//

import UIKit
import CoreData

class CoreData {
    
     func fetchCoreData() -> NSData? {
        // UIApplication.shared.delegate - доступ к глобальному делегату
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "MainEntity")
        
        do {
            let fetchResults = try managedContext.fetch(request)
            
            let data = fetchResults.first?.value(forKey: "data") as? NSData
            return data
            
        } catch {
            print("could not fetch data \(error.localizedDescription)")
        }
        return nil
    }
    
     func saveCoreData(data: NSData) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MainEntity", in: managedContext)!
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "MainEntity")
        
        do {
            let fetchResults = try managedContext.fetch(request)
            if fetchResults.count == 0 {
                let nsmanagedObject = NSManagedObject(entity: entity, insertInto: managedContext)
                
                nsmanagedObject.setValue(data, forKeyPath: "data")
            } else {
                let customResults = fetchResults.first!
                
                customResults.setValue(data, forKey: "data")
            }
            try managedContext.save()
        } catch {
            print("Error, could not save data \(error.localizedDescription)")
        }
    }
}
