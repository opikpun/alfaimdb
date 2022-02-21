//
//  MovieItemCell.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import UIKit

class MovieItemCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
