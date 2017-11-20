//
//  EditingViewController.swift
//  ModuleHomeWork
//
//  Created by Admin on 15.11.17.
//  Copyright © 2017 Bioprom. All rights reserved.
//

import UIKit

class EditingViewController: UIViewController {
    

    @IBOutlet weak var ibButtonSave: UIBarButtonItem!
    @IBOutlet weak var ibNameTextField: UITextField!
    @IBOutlet weak var ibEmailTextField: UITextField!
    @IBOutlet weak var ibTelephoneTextField: UITextField!
    @IBOutlet weak var ibSurnameTextField: UITextField!
    var contact: ContactUser?
    var isAddContact = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    private func setupViewController() {
        if  contact != nil {
            title = "Редактировать"
            setTextFields()
            ibButtonSave.title = "Изменить"
            isAddContact = false
        } else {
            title = "Создать"
            ibButtonSave.title = "Добавить"
            isAddContact = true
        }
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    private func setTextFields() {
        guard let contact = contact else {return}
        ibNameTextField.text = contact.name
        ibSurnameTextField.text = contact.surname
        ibTelephoneTextField.text = contact.telephone
        ibEmailTextField.text = contact.email
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

}

// MARK: - UITextFieldDelegate
extension EditingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hideKeyboard()
        return true
    }
}
