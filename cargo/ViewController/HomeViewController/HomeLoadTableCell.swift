//
//  HomeLoadTableCell.swift
//  cargo
//
//  Created by Apple on 9/25/23.
//

import UIKit

class HomeLoadTableCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerView.setBorder(UIColor(named: "ViewBorder")!, cornerRadius: Constants.cornerRadius1)
        addressView.setBorder(UIColor(named: "ViewBorderThick")!, cornerRadius: Constants.cornerRadius1)
        
        viewButton.setBorder(UIColor(named: "ViewBorderThick")!)
        acceptButton.setBorder(UIColor(named: "TextGray")!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
