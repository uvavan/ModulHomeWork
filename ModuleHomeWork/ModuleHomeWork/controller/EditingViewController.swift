//
//  EditingViewController.swift
//  ModuleHomeWork
//
//  Created by Admin on 15.11.17.
//  Copyright © 2017 Bioprom. All rights reserved.
//

import UIKit

class EditingViewController: UIViewController {
    
    @IBOutlet private weak var ibImageContact: UIImageView!
    @IBOutlet private weak var ibButtonSave: UIBarButtonItem!
    @IBOutlet private weak var ibNameTextField: UITextField!
    @IBOutlet private weak var ibEmailTextField: UITextField!
    @IBOutlet private weak var ibTelephoneTextField: UITextField!
    @IBOutlet private weak var ibSurnameTextField: UITextField!
    private var isAddContact: Bool {
        return contact != nil
    }
    private var keyboardIsHidden = true
    var contact: ContactUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addAllObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func addAllObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
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
        ibNameTextField.delegate = self
        ibSurnameTextField.delegate = self
        ibEmailTextField.delegate = self
        ibTelephoneTextField.delegate = self
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectRecognizerTap(_:)))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func selectRecognizerTap(_ sender: UITapGestureRecognizer) {
        let iconImagePoint = sender.location(in: ibImageContact)
        if ibImageContact.point(inside: iconImagePoint, with: nil), keyboardIsHidden {
            tapInIconImage()
        } else {
            hideKeyboard()
        }
    }
    
    private func tapInIconImage() {
        let alertVC = UIAlertController(title: "Выберите источник", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Камера", style: .default) { _ in
        }
        let galleryAction = UIAlertAction(title: "Галерея", style: .default) {_ in
        }
        let canceledAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(galleryAction)
        alertVC.addAction(canceledAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func setTextFields() {
        guard let contact = contact else {return}
        ibNameTextField.text = contact.name
        ibSurnameTextField.text = contact.surname
        ibTelephoneTextField.text = contact.telephone
        ibEmailTextField.text = contact.email
    }
    
    @IBAction private func ibButtonSavePress(_ sender: Any) {
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
    
    private func hideKeyboard() {
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

//MARK: - Notification
extension EditingViewController {
    @objc private func keyboardWillShow(_ notification: Notification) {
        keyboardIsHidden = false
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardIsHidden = true
    }
}
