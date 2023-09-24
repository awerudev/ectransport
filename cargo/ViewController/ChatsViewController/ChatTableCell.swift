//
//  ChatTableCell.swift
//  cargo
//
//  Created by Apple on 9/24/23.
//

import UIKit

class ChatTableCell: UITableViewCell {

    @IBOutlet weak var newMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        newMessageLabel.layer.cornerRadius = 11
        newMessageLabel.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
