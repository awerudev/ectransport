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
    
    @IBOutlet weak var loadNoLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var delivertoAddressLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
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

    // MARK: - My Method
    
    func showLoadInfo(_ loadData: LoadData) {
        loadNoLabel.text = "Load #\(loadData.id)"
        priceLabel.isHidden = true
        pickupAddressLabel.text = loadData.pickupAt.formattedAddress.isEmpty ? "-": loadData.pickupAt.formattedAddress
        delivertoAddressLabel.text = loadData.deliverTo.formattedAddress.isEmpty ? "-": loadData.deliverTo.formattedAddress
        milesLabel.text = loadData.miles.isEmpty ? "-": "\(loadData.miles) miles"
        weightLabel.text = loadData.weight.isEmpty ? "-": "\(loadData.weight) lb"
    }
}
