//
//  ViewController.swift
//  ModuleHomeWork
//
//  Created by Admin on 15.11.17.
//  Copyright © 2017 Bioprom. All rights reserved.
//

import UIKit

class TabelViewController: UIViewController {
    
    @IBOutlet weak var ibContactTableView: UITableView!
    private var datasource: [Character : [ContactUser]] = [:]
    private var keyCharacter: [Character] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Контакты"
        setupDatasource()
        setupTable()
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
        return 120
    }

}
