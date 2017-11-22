//
//  EditingViewController.swift
//  ModuleHomeWork
//
//  Created by Admin on 15.11.17.
//  Copyright © 2017 Bioprom. All rights reserved.
//

import UIKit

class EditingViewController: UIViewController {

    @IBOutlet weak var ibImageContact: UIImageView!
    @IBOutlet weak var ibButtonSave: UIBarButtonItem!
    @IBOutlet weak var ibNameTextField: UITextField!
    @IBOutlet weak var ibEmailTextField: UITextField!
    @IBOutlet weak var ibTelephoneTextField: UITextField!
    @IBOutlet weak var ibSurnameTextField: UITextField!
    var contact: ContactUser?
    private var isAddContact = false

    override func viewDidLoad() {
        super.viewDidLoad()
        isAddContact = contact != nil ? true : false
        setupViewController()
    }
    
    private func setupViewController() {
        if  isAddContact {
            title = "Редактировать"
            setTextFields()
            ibButtonSave.title = "Изменить"
        } else {
            title = "Создать"
            ibButtonSave.title = "Добавить"
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
    
    @IBAction func ibButtonSave(_ sender: Any) {
        let newName = ibNameTextField.text ?? ""
        let newSurname = ibSurnameTextField.text ?? ""
        let newEmail = ibEmailTextField.text ?? ""
        let newTel = ibTelephoneTextField.text ?? ""
        guard !newName.isEmpty, !newSurname.isEmpty else {
                let alertVC = UIAlertController(title: "", message: "Введите имя и фамилию", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC, animated: true, completion: nil)
                return
        }
        if isAddContact {
            contact?.name = newName
            contact?.surname = newSurname
            contact?.email = newEmail
            contact?.telephone = newTel
            guard let editingContact = contact else {return}
            DataManager.instance.editingContact(editingContact)
        } else {
            let newContact = ContactUser(name: newName, surname: newSurname, email: newEmail, telephone: newTel, ibImageContact.image)
            DataManager.instance.addContact(newContact)
        }
        navigationController?.popViewController(animated: true)
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
