//
//  UITableView+Extension.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import UIKit

extension UITableView {
    func registerNib<T: UITableViewCell>(forCell: T.Type) {
        register(UINib(nibName: String(describing: T.self), bundle: nil), forCellReuseIdentifier: String(describing: T.self))
    }
}
