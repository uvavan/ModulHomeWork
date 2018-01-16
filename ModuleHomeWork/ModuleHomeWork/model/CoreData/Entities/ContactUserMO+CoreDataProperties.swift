//
//  ContactUserMO+CoreDataProperties.swift
//  ModuleHomeWork
//
//  Created by Admin on 16.01.2018.
//  Copyright © 2018 Bioprom. All rights reserved.
//
//

import Foundation
import CoreData


extension ContactUserMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactUserMO> {
        return NSFetchRequest<ContactUserMO>(entityName: "ContactUserMO")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var email: String?
    @NSManaged public var telephone: String?

}
