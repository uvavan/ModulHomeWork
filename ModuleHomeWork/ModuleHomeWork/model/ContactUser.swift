//
//  ContactUser.swift
//  ModuleHomeWork
//
//  Created by Admin on 15.11.17.
//  Copyright © 2017 Bioprom. All rights reserved.
//

import UIKit

class ContactUser {
    var name: String = ""
    var surname: String = ""
    var email: String = ""
    var telephone: String = ""
    var icon: UIImage! = nil
    
    init(name: String, surname: String, email: String, telephone: String, _ icon: UIImage! = nil) {
        self.name = name
        self.surname = surname
        self.email = email
        self.telephone = telephone
        self.icon = icon
    }
}
