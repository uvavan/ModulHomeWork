//
//  ViewController.swift
//  ModuleHomeWork
//
//  Created by Admin on 15.11.17.
//  Copyright © 2017 Bioprom. All rights reserved.
//

import UIKit

class ContactsTabelViewController: UIViewController {
    
    @IBOutlet private weak var ibSearch: UISearchBar!
    @IBOutlet private weak var ibContactTableView: UITableView!
    private var datasource: [Character : [ContactUser]] = [:]
    private var keyCharacter: [Character] = []
    private var isSearchActive = false
    private var filteredData: [ContactUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Контакты"
        ibSearch.delegate = self
        setupDatasource()
        setupTable()
        addNotification()
    }

    private func addNotification () {
        NotificationCenter.default.addObserver(self, selector: #selector(delContact), name: .ContactDeleted, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addContact), name: .ContactAdd, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editingContact), name: .ContactEditing, object: nil)
    }
    
    private func setupTable() {
        ibContactTableView.delegate = self
        ibContactTableView.dataSource = self
        ibContactTableView.keyboardDismissMode = .onDrag
        ibContactTableView.register(ContactTableViewCell.nib, forCellReuseIdentifier: ContactTableViewCell.reuseIdentifier)
    }
    
    private func getContact(for indexPath: IndexPath) -> ContactUser? {
        let key = keyCharacter[indexPath.section]
        let contactsForSection = datasource[key]
        return isSearchActive ? filteredData[indexPath.row] : contactsForSection?[indexPath.row]
    }
    
    private func setupDatasource() {
        let name = ibSearch.text ?? ""
        isSearchActive = !name.isEmpty
        if isSearchActive {
            filterContent(byName: name)
        } else {
            setupTabelContent()
        }
    }
    
    private func setupTabelContent() {
        let contacts = DataManager.instance.contacts
        datasource = [:]
        keyCharacter = []
        for contact in contacts {
            if let firstChart = contact.name.first {
                var newContacts = datasource[firstChart] ?? []
                newContacts.append(contact)
                datasource[firstChart] = newContacts
            }
        }
        keyCharacter = Array(datasource.keys).sorted()
        ibContactTableView.reloadData()
    }
    
    private func filterContent(byName name: String) {
        if !name.isEmpty {
            let contacts = DataManager.instance.contacts
            filteredData.removeAll()
            for contact in contacts {
                if contact.fullName.lowercased().contains(name.lowercased()) {
                    filteredData.append(contact)
                }
            }
        }
        ibContactTableView.reloadData()
    }
    
    @IBAction private func buttonPressAddContact(_ sender: Any) {
        performSegue(withIdentifier: "showContact", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destVC = segue.destination as? EditingViewController else {return}
        guard let indexPath = sender as? IndexPath else {return}
        destVC.contact = getContact(for: indexPath)
    }
    
}

// MARK: - Table view datasource
extension ContactsTabelViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearchActive ? 1 : keyCharacter.count
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
        cell.update(fullName: item.fullName, telephone: item.telephone, icon: iconImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = keyCharacter[section]
        let contactsForSection = datasource[key] ?? []
        return  isSearchActive ? filteredData.count : contactsForSection.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isSearchActive ? "" : String(keyCharacter[section])
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
        DataManager.instance.deleteContac(contact)
    }
}

extension ContactsTabelViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //filterContent(byName: searchText)
        setupDatasource()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension ContactsTabelViewController {
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
