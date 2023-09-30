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
    @IBOutlet weak var yourBidLabel: UILabel!
    @IBOutlet weak var perMileLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var piecesLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var dimsLabel: UILabel!
    @IBOutlet weak var expireAtLabel: UILabel!
    
    /// 140
    @IBOutlet weak var infoViewHeight: NSLayoutConstraint!
    
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
    
    // MARK: - My Method
    
    func showLoadInfo(_ loadData: LoadData) {
        milesLabel.text = loadData.miles.isEmpty ? "-": "\(loadData.miles) miles"
        piecesLabel.text = loadData.pieces.isEmpty ? "-": loadData.pieces
        weightLabel.text = loadData.weight.isEmpty ? "-": "\(loadData.weight) lb"
        dimsLabel.text = loadData.dims.isEmpty ? "-": loadData.dims
        expireAtLabel.text = loadData.expireAt.isEmpty ? "-": loadData.expireAt
    }
    
    func showPriceInfo(bidPrice: Double, milePrice: Double) {
        yourBidLabel.text = String(format: "$%.2f", bidPrice)
        perMileLabel.text = String(format: "$%.2f", milePrice)
        
        if bidPrice < 0.01 {
            yourBidLabel.textColor = UIColor(named: "TextDark")
        }
        else {
            yourBidLabel.textColor = UIColor(named: "TextGreenLight")
        }
        if milePrice < 0.01 {
            perMileLabel.textColor = UIColor(named: "TextDark")
        }
        else {
            perMileLabel.textColor = UIColor(named: "TextGreenLight")
        }
    }    
    
}
