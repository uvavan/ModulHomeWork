//
//  ViewController.swift
//  ModuleHomeWork
//
//  Created by Admin on 15.11.17.
//  Copyright © 2017 Bioprom. All rights reserved.
//

import UIKit

class TabelViewController: UIViewController {
    
    @IBOutlet  weak private var ibContactTableView: UITableView!
    private var datasource: [Character : [ContactUser]] = [:]
    private var keyCharacter: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Контакты"
        setupDatasource()
        setupTable()
        addNotification()
    }

    private func addNotification () {
        NotificationCenter.default.addObserver(self, selector: #selector(delContact), name: .ContactDeleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addContact), name: .ContactAdd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editingContact), name: .ContactEditing, object: nil)
    }
    
    private func setupTable(){
        ibContactTableView.delegate = self
        ibContactTableView.dataSource = self
        ibContactTableView.keyboardDismissMode = .onDrag
        ibContactTableView.register(ContactTableViewCell.nib, forCellReuseIdentifier: ContactTableViewCell.reuseIdentifier)
    }
    
    private func getContact(for indexPath: IndexPath) -> ContactUser? {
        let key = keyCharacter[indexPath.section]
        let contactsForSection = datasource[key]
        return contactsForSection?[indexPath.row]
    }
    
    private func setupDatasource() {
        let contacts = DataManager.instance.contacts
        datasource = [:]
        keyCharacter = []
        for contact in contacts {
            if let firstChart = contact.surname.first {
                var newContacts = datasource[firstChart] ?? []
                newContacts.append(contact)
                datasource[firstChart] = newContacts
            }
        }
        keyCharacter = Array(datasource.keys).sorted()
        ibContactTableView.reloadData()
    }
    
    @IBAction  private func buttonPressAddContact(_ sender: Any) {
        performSegue(withIdentifier: "showContact", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? EditingViewController else {return}
        guard let indexPath = sender as? IndexPath else {return}
        destVC.contact = getContact(for: indexPath)
    }
    
}

// MARK: - Table view datasource
extension TabelViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keyCharacter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseIdentifier) as?
            ContactTableViewCell else {
                fatalError("Error: Cell dosn`t exist")
        }
        guard let item = getContact(for: indexPath) else {
            fatalError("Error: Error inex Path")
        }
        let iconImage = item.icon ?? #imageLiteral(resourceName: "user-6")
        cell.update(name: item.name, surname: item.surname, telephone: item.telephone, icon: iconImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = keyCharacter[section]
        let contactsForSection = datasource[key] ?? []
        return contactsForSection.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(keyCharacter[section])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showContact", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCellEditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        guard let contact = getContact(for: indexPath) else {return}
        DataManager.instance.delContac(contact)
    }
}

extension TabelViewController {
    @objc private func delContact () {
        setupDatasource()
    }
    
    @objc private func addContact() {
        setupDatasource()
    }
    
    @objc private func editingContact() {
        setupDatasource()
    }
}
