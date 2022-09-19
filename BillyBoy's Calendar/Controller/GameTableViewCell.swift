//
//  GameTableViewCell.swift
//  BillyBoy's Calendar
//
//  Created by Bogdan Anishchenkov on 19.09.2022.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    
    @IBOutlet var gameImage: UIImageView!
    
    @IBOutlet var gameTitleLabel: UILabel!
    @IBOutlet var gameReleaseDateLabel: UILabel!
    @IBOutlet var gameGenreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
