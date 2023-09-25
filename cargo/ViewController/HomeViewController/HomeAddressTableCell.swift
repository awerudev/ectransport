//
//  HomeAddressTableCell.swift
//  cargo
//
//  Created by Apple on 9/25/23.
//

import UIKit

class HomeAddressTableCell: UITableViewCell {
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressInputView: UIView!
    @IBOutlet weak var scheduleButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Address View
        addressView.setBorder(UIColor(named: "ViewBorder")!, width: 1, cornerRadius: Constants.cornerRadius1)
        addressInputView.setBorder()
        
        // Schedule Button
        scheduleButton.setBorder(UIColor(named: "TextGray")!, width: 1, cornerRadius: scheduleButton.frame.size.height / 2)
//        scheduleButton.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
