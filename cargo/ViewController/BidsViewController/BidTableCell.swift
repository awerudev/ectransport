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
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var deliverToAddressLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Shadow Effect
        containerView.setShadow()
        
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
    
    // MARK: - My Method
    
    func showLoadInfo(_ loadInfo: LoadData) {
        pickupAddressLabel.text = loadInfo.pickupAt.formattedAddress.isEmpty ? "-": loadInfo.pickupAt.formattedAddress
        deliverToAddressLabel.text = loadInfo.deliverTo.formattedAddress.isEmpty ? "-": loadInfo.deliverTo.formattedAddress
        milesLabel.text = loadInfo.miles.isEmpty ? "-": "\(loadInfo.miles) miles"
        weightLabel.text = loadInfo.weight.isEmpty ? "-": "\(loadInfo.weight) lb"
    }

}
