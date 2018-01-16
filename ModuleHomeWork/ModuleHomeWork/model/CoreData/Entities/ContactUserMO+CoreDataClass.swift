//
//  ContactUserMO+CoreDataClass.swift
//  ModuleHomeWork
//
//  Created by Admin on 16.01.2018.
//  Copyright © 2018 Bioprom. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ContactUserMO)
public class ContactUserMO: NSManagedObject {
    
    //private var viewContext: NSManagedObjectContext { return CoreDataManager.instance.persistentContainer.viewContext }
    
    func getContact() -> ContactUser {
        return ContactUser.init(id: Int(self.id), name: self.name ?? "", surname: self.surname ?? "", email: self.email ?? "", telephone: self.telephone ?? "")
    }
    
    func setContact(_ contact: ContactUser) {
        self.name = contact.name
        self.id = Int64(contact.id)
        self.email = contact.email
        self.surname = contact.surname
        self.telephone = contact.telephone
    }
    
}
