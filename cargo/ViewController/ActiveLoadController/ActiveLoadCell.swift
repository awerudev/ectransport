//
//  ActiveLoadCell.swift
//  cargo
//
//  Created by Apple on 10/15/23.
//

import UIKit

class ActiveLoadCell: UITableViewCell {
    
    @IBOutlet weak var loadNoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
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
