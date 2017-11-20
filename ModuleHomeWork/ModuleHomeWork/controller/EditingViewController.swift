//
//  EditingViewController.swift
//  ModuleHomeWork
//
//  Created by Admin on 15.11.17.
//  Copyright © 2017 Bioprom. All rights reserved.
//

import UIKit

class EditingViewController: UIViewController {
    
    var contact: ContactUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = contact != nil ? "Редактировать" : "Создать"
    }

}
