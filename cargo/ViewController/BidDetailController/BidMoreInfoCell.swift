//
//  BidMoreInfoCell.swift
//  cargo
//
//  Created by Apple on 9/24/23.
//

import UIKit

class BidMoreInfoCell: UITableViewCell {

    @IBOutlet weak var yourBidView: UIView!
    @IBOutlet weak var perMileView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        yourBidView.setBorder(UIColor(named: "ViewBorder")!, cornerRadius: Constants.cornerRadius1)
        perMileView.setBorder(UIColor(named: "ViewBorder")!, cornerRadius: Constants.cornerRadius1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
