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
    private init() {
        generateDate()
    }
    
    private(set) var contacts: [ContactUser] = []
    
    //MARK: - Private methods
    private func generateDate() {
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
    }
    
    func delContac(_ contact: ContactUser) {
        guard !contacts.isEmpty else {return}
        guard let index = getIndex(of: contact) else {return}
        contacts.remove(at: index)
        NotificationCenter.default.post(name: .ContactDeleted, object: nil)
    }
    
    func getIndex(of contact: ContactUser) -> Int? {
        var indexOfContact: Int?
        for (index,item) in contacts.enumerated() {
            if item.telephone == contact.telephone {
                indexOfContact = index
                break
            }
        }
        return indexOfContact
    }
}
