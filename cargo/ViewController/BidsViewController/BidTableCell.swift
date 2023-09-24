//
//  BidTableCell.swift
//  cargo
//
//  Created by Apple on 9/21/23.
//

import UIKit

class BidTableCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var seeDetailsView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Shadow Effect
        containerView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowRadius = Constants.cornerRadius1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.cornerRadius = Constants.cornerRadius1
        containerView.backgroundColor = UIColor(named: "White")
        
        addressView.setBorder(UIColor(named: "ViewBorder")!, width: 1, cornerRadius: Constants.cornerRadius0)
        
        seeDetailsView.setBorder(UIColor(named: "InputBorder")!, width: 1, cornerRadius: Constants.cornerRadius0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
