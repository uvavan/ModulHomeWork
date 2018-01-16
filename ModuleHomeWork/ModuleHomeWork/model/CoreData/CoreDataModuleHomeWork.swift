//
//  CoreDataModuleHomeWork.swift
//  ModuleHomeWork
//
//  Created by Admin on 16.01.2018.
//  Copyright © 2018 Bioprom. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let instance = CoreDataManager()
    private init() {}

    private var viewContext: NSManagedObjectContext { return CoreDataManager.instance.persistentContainer.viewContext }
    
    // MARK: - func work CoreData
    func saveContactsList(_ contacts: [ContactUser]) {
        CoreDataManager.instance.persistentContainer.performBackgroundTask { bgContext in
            for item in contacts {
                let contact = ContactUserMO(context: bgContext)
                contact.setContact(item)
            }
            try? bgContext.save()
        }
    }
    
    func fetchContactsList() -> [ContactUser] {
        let fetch: NSFetchRequest<ContactUserMO> = ContactUserMO.fetchRequest()
        var contacts: [ContactUser] = []
        let datasource = (try? viewContext.fetch(fetch)) ?? []
        for item in datasource {
            let contact = item.getContact()
            contacts.append(contact)
        }
        return contacts
    }
    
    func deleteContact(_ contact: ContactUser) {
        CoreDataManager.instance.persistentContainer.performBackgroundTask { [weak self] bgContext in
            let namePredicate = NSPredicate(format: ("\(#keyPath(ContactUserMO.name)) like \'\(contact.name)\'"))
            let fetch: NSFetchRequest<ContactUserMO> = ContactUserMO.fetchRequest()
            fetch.predicate = namePredicate
            let contactList = try? bgContext.fetch(fetch)
            guard let item = contactList?.first else {return}
            bgContext.delete(item)
            try? bgContext.save()
            self?.postMainQueueNotification(withName: .ContactDeleted)
        }
    }
    
    func addContact(_ contact: ContactUser) {
        CoreDataManager.instance.persistentContainer.performBackgroundTask { [weak self] bgContext in
            let item = ContactUserMO(context: bgContext)
            item.setContact(contact)
            try? bgContext.save()
            self?.postMainQueueNotification(withName: .ContactAdd)
        }
    }
    
    private func postMainQueueNotification(withName name: Notification.Name, userInfo: [AnyHashable: Any]? = nil ) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
        }
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ModuleHomeWork")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
