//
//  HomeTransitTableCell.swift
//  cargo
//
//  Created by Apple on 9/25/23.
//

import UIKit

class HomeTransitTableCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        timeView.setBorder()
        addressView.setBorder()
        
        actionButton.layer.cornerRadius = actionButton.frame.size.height / 2
        actionButton.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
