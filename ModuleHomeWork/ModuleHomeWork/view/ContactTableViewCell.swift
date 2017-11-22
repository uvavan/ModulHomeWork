//
//  ContactTableViewCell.swift
//  ModuleHomeWork
//
//  Created by Admin on 15.11.17.
//  Copyright © 2017 Bioprom. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ContactTableViewCell.self)
    static let nib = UINib(nibName: String(describing: ContactTableViewCell.self), bundle: nil)

    @IBOutlet private weak var ibImage: UIImageView!
    @IBOutlet private weak var ibLabelFullName: UILabel!
    @IBOutlet private weak var ibLabelTelephone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func update (fullName: String, telephone: String, icon: UIImage) {
        ibImage.image = icon
        ibLabelFullName.text = fullName
        ibLabelTelephone.text = telephone
    }
    
}
