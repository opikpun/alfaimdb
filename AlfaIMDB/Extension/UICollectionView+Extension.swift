//
//  UICollectionView+Extension.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import UIKit

extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(forCell: T.Type) {
        register(UINib(nibName: String(describing: T.self), bundle: nil), forCellWithReuseIdentifier: String(describing: T.self))
    }
}
