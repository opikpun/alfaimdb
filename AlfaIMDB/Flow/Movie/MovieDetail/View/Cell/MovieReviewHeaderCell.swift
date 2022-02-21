//
//  MovieReviewHeaderCell.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import UIKit

class MovieReviewHeaderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
