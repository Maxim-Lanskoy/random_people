//
//  CoreDataManager.swift
//  Random People
//
//  Created by Maxim Lanskoy on 10.10.2018.
//  Copyright © 2018 Lanskoy. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    // Class singletone
    
    static let shared = CoreDataManager()
    
    // MARK: - utility routines
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    // MARK: - Core Data stack (generic)
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "RandomPeople", withExtension: "momd")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("RandomPeople").appendingPathExtension("xcdatamodeld")
        
        do {
            let options = [ NSMigratePersistentStoresAutomaticallyOption : 1,
                            NSInferMappingModelAutomaticallyOption : 1]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            let dict : [String : Any] = [NSLocalizedDescriptionKey        : "Failed to initialize the application's saved data" as NSString,
                                         NSLocalizedFailureReasonErrorKey : "There was an error creating or loading the application's saved data." as NSString,
                                         NSUnderlyingErrorKey             : error as NSError]
            
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            fatalError("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
        }
        
        return coordinator
    }()
    
    // MARK: - Core Data stack (iOS 9)
    
    @available(iOS 9.0, *)
    lazy var managedObjectContext: NSManagedObjectContext = {
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data stack (iOS 10)
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RandomPeople")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError?
            {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        )
        
        return container
    }()
    
    // MARK: - Core Data context
    
    lazy var databaseContext : NSManagedObjectContext = {
        if #available(iOS 10.0, *) {
            return self.persistentContainer.viewContext
        } else {
            return self.managedObjectContext
        }
    }()
    
    // MARK: - Core Data save
    
    func saveContext(completion: (() -> Swift.Void)? = nil) {
        do {
            if #available(iOS 10.0, *) {
                if (self.persistentContainer.viewContext.hasChanges) {
                    try self.persistentContainer.viewContext.save()
                } else if self.managedObjectContext.hasChanges {
                    try self.managedObjectContext.save()
                }
            } else {
                if self.managedObjectContext.hasChanges {
                    try self.managedObjectContext.save()
                }
            }
            //          if databaseContext.hasChanges {
            //              try databaseContext.save()
            //          }
            if let saveContextCompletion = completion {
                saveContextCompletion()
            }
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: - Core Data Deleting support
    
    func deleteAllData (completion: (() -> Swift.Void)? = nil) {
        if let psc = self.managedObjectContext.persistentStoreCoordinator {
            
            let store: NSPersistentStore = (psc.persistentStores.last)! as NSPersistentStore
            let storeUrl = psc.url(for: store)
            
            self.managedObjectContext.performAndWait(){
                
                self.managedObjectContext.reset()
                do {
                    try psc.remove(store)
                    try FileManager.default.removeItem(at: storeUrl)
                    try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeUrl, options: nil)
                    
                    if let deleteCompletion = completion {
                        deleteCompletion()
                    }
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    func saveUsers(users: [User], completion: (() -> Swift.Void)? = nil) {
        // Remove old entities.
        self.deleteAllData(completion: {
            // Create new entities.
            if users.isEmpty {
                print("ERROR: Users Array is Empty!")
                return
            }
            
            var cdUsersArray: [CDUser] = []
            for (index, user) in users.enumerated() {
                let cdUser = NSEntityDescription.insertNewObject(forEntityName: "User", into: self.managedObjectContext) as! CDUser
                cdUser.id = Int32(index)
                cdUser.firstName = user.firstName
                cdUser.lastName = user.lastName
                cdUser.title = user.title
                cdUser.gender = user.gender
                cdUser.phone = user.phone
                cdUser.dateOfRegistration = user.dateOfRegistration
                cdUser.dateOfBirth = user.dateOfBirth
                cdUser.city = user.city
                cdUser.street = user.street
                cdUser.state = user.state
                cdUser.postcode = Int32(user.postCode ?? 0)
                cdUser.userAvatar = user.userAvatar != nil ? "\(user.userAvatar!)" : ""
                cdUser.nationality = user.nationality?.rawValue
                cdUsersArray.append(cdUser)
            }
            
            self.saveContext(completion: {
                if let downloadCompletion = completion {
                    downloadCompletion()
                }
            })
            
        })
    }
    
    func fetchAllUsers () -> Array<CDUser>? {
        let usersFetch = NSFetchRequest<CDUser>(entityName: "User")
        let sortDescriptor = NSSortDescriptor (key: "id", ascending: true)
        usersFetch.sortDescriptors = [sortDescriptor]
        usersFetch.returnsObjectsAsFaults = false
        do {
            let fetchedUsersRequest = try self.managedObjectContext.fetch(usersFetch as! NSFetchRequest<NSFetchRequestResult>) as? [CDUser]
            return fetchedUsersRequest
        } catch {
            fatalError("Failed to fetch user: \(error)")
        }
    }
}
