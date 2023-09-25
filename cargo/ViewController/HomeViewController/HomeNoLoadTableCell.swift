//
//  HomeNoLoadTableCell.swift
//  cargo
//
//  Created by Apple on 9/25/23.
//

import UIKit

class HomeNoLoadTableCell: UITableViewCell {
        
    @IBOutlet weak var findLoadView: UIView!
    @IBOutlet weak var findLoadButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Find Loads
        findLoadView.setBorder(UIColor(named: "ViewBorder")!, width: 1, cornerRadius: Constants.cornerRadius1)
        findLoadButton.setBorder(UIColor(named: "TextGray")!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
