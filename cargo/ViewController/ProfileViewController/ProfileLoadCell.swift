//
//  ProfileLoadCell.swift
//  cargo
//
//  Created by Apple on 9/24/23.
//

import UIKit

class ProfileLoadCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var addressView: UIView!
    
    @IBOutlet weak var loadNoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var deliverToAddressLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - My Method
    
    func showBidInfo(_ bidInfo: BidInfo) {
        loadNoLabel.text = "Load #\(bidInfo.id)"
        priceLabel.text = String(format: "$%.2f", bidInfo.totalPrice)
        pickupAddressLabel.text = bidInfo.pickupAt.formattedAddress.isEmpty ? "-": bidInfo.pickupAt.formattedAddress
        deliverToAddressLabel.text = bidInfo.deliverTo.formattedAddress.isEmpty ? "-": bidInfo.deliverTo.formattedAddress
        milesLabel.text = bidInfo.miles.isEmpty ? "-": "\(bidInfo.miles) miles"
        weightLabel.text = bidInfo.weight.isEmpty ? "-": "\(bidInfo.weight) lb"
    }

}
