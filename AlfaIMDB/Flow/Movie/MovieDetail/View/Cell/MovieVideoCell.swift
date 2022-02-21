//
//  MovieVideoCell.swift
//  AlfaIMDB
//
//  Created by Taufik Rohmat on 21/02/22.
//

import UIKit
import youtube_ios_player_helper

class MovieVideoCell: UITableViewCell {
    
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
