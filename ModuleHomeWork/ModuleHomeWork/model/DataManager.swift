//
//  DataManager.swift
//  ModuleHomeWork
//
//  Created by Admin on 15.11.17.
//  Copyright © 2017 Bioprom. All rights reserved.
//

import UIKit

final class DataManager {
    static let instance = DataManager()
    private(set) var contacts: [ContactUser] = []
    
    private init() {}
    
    // MARK: - Private methods
    func generateDate() {
        var contacts: [ContactUser] = []
        contacts.append(ContactUser(name: "Иван", surname: "Иванов",
                                    email: "ivanovI@gmail.com", telephone: "+380903333333"))
        contacts.append(ContactUser(name: "Андрей", surname: "Абрамов",
                                    email: "andreyA@mail.ru", telephone: "+79252223443"))
        contacts.append(ContactUser(name: "Александр", surname: "Яковенко",
                                    email: "AlexYkovenko@gmail.com", telephone: "+380635675490"))
        contacts.append(ContactUser(name: "Анатолий", surname: "Коростенев",
                                    email: "AnKoroct@gmail.com", telephone: "+380994567890"))
        contacts.append(ContactUser(name: "Игорь", surname: "Шепотов",
                                    email: "Shepot@mail.ru", telephone: "+380949385678"))
        contacts.append(ContactUser(name: "Кирил", surname: "Арехов",
                                    email: "ArehK@mail.ru", telephone: "+380978678958"))
        CoreDataManager.instance.saveContactsList(contacts)
    }
    
    private func getIndex(of contact: ContactUser) -> Int? {
        var indexOfContact: Int?
        for (index, item) in contacts.enumerated() where item.id == contact.id {
                indexOfContact = index
                break
        }
        return indexOfContact
    }
    
    func getContactsList() {
       contacts = CoreDataManager.instance.fetchContactsList()
    }
    
    // MARK: - Editing data methods
    func deleteContac(_ contact: ContactUser) {
        guard !contacts.isEmpty else {return}
        guard let index = getIndex(of: contact) else {return}
        contacts.remove(at: index)
        CoreDataManager.instance.deleteContact(contact)
        //NotificationCenter.default.post(name: .ContactDeleted, object: nil)
    }
    
    func addContact (_ contact: ContactUser) {
        contacts.append(contact)
        CoreDataManager.instance.addContact(contact)
       // NotificationCenter.default.post(name: .ContactAdd, object: nil)
    }
    
    func editingContact(_ contact: ContactUser) {
        guard !contacts.isEmpty else {return}
        guard let index = getIndex(of: contact) else {return}
        contacts[index].name = contact.name
        contacts[index].surname = contact.surname
        contacts[index].email = contact.email
        contacts[index].telephone = contact.telephone
        contacts[index].icon = contact.icon
        NotificationCenter.default.post(name: .ContactEditing, object: nil)
    }
    
}
