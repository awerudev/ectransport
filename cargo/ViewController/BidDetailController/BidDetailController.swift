//
//  BidDetailController.swift
//  cargo
//
//  Created by Apple on 9/24/23.
//

import UIKit
import MBProgressHUD

class BidDetailController: UIViewController {
    
    var loadInfo: LoadData? = nil
    var bidInfo: BidInfo? = nil
    var accept = false

    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelBidButton: UIButton!
    @IBOutlet weak var placeBidButton: UIButton!
    
    @IBOutlet weak var pickupAddressLabel: UILabel!
    @IBOutlet weak var deliverToAddressLabel: UILabel!
    @IBOutlet weak var pickupDateLabel: UILabel!
    @IBOutlet weak var deliveryDateLabel: UILabel!        
    
    private var bidPrice: Double = 0
    
    private var isMoreInfo = false
    
    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initLayout()
        updateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        getBidBy()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if accept {
            onClickPlaceBid(placeBidButton)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - My Method

    private func initLayout() {
        // Navigation Bar
        navigationItem.title = "Bid offer details"
        
        // Address View
        addressView.setBorder(UIColor(named: "BlueTrans20")!, width: 1, cornerRadius: Constants.cornerRadius0)
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // Bottom View
        bottomView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08).cgColor
        bottomView.layer.shadowOpacity = 1
        bottomView.layer.shadowRadius = Constants.cornerRadius1
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        cancelBidButton.setBorder(UIColor(named: "ViewBorderThick")!)
        placeBidButton.setBorder(UIColor(named: "TextGray")!)
        
        if let loadInfo = loadInfo {
            pickupAddressLabel.text = loadInfo.pickupAt.formattedAddress.isEmpty ? "-": loadInfo.pickupAt.formattedAddress
            deliverToAddressLabel.text = loadInfo.deliverTo.formattedAddress.isEmpty ? "-": loadInfo.deliverTo.formattedAddress
            pickupDateLabel.text = loadInfo.pickupDate.isEmpty ? "-": loadInfo.pickupDate
            deliveryDateLabel.text = loadInfo.deliverDate.isEmpty ? "-": loadInfo.deliverDate
        }
    }
    
    private func updateLayout() {
        DispatchQueue.main.async {
            if self.bidInfo != nil {
//                self.placeBidButton.isEnabled = false
//                self.placeBidButton.setTitle("Already placed", for: .normal)
                
                self.tableView.reloadData()
            }
            else {
//                self.placeBidButton.isEnabled = true
//                self.placeBidButton.setTitle("Place bid", for: .normal)
                
                self.tableView.reloadData()
            }
        }
    }
    
    private func getBidBy() {
        guard let loadInfo = loadInfo else {
            return
        }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        FirebaseService.getBidBy(id: "\(loadInfo.id)") { bid, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let bid = bid {
                self.bidPrice = bid.totalPrice
                self.bidInfo = bid
                
                self.updateLayout()
            }
        }
    }
    
    private func placeBid() {
        guard let loadInfo = loadInfo else {
            return
        }
        
        var bid = loadInfo.toBidInfo()
        bid.totalPrice = bidPrice
        
        MBProgressHUD.showAdded(to: view, animated: true)
        FirebaseService.addBid(bid) { error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                Alert.showAlert(Constants.appName, message: "Your Bid Has Been Placed Please Hold for 20 Minutes.", from: self) { action in
                    
                }
                // Success
                self.bidInfo = bid
                self.updateLayout()
            }
        }
    }
    
    private func cancelBid() {
        guard let bidInfo = bidInfo else {
            return
        }
        
        MBProgressHUD.showAdded(to: view, animated: true)
        FirebaseService.cancelBidBy(id: "\(bidInfo.id)") { error in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            self.bidInfo = nil
            self.updateLayout()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Action
    
    @IBAction func onClickPlaceBid(_ sender: UIButton) {
        if self.bidInfo != nil {
            Alert.showAlert(Constants.appName, message: "You already placed bid for this load!", from: self, handler: nil)
            return
        }
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "PlaceBidController") as? PlaceBidController else {
            return
        }
        vc.onPlacePrices = { (total) in
            self.bidPrice = total
            
            self.tableView.reloadData()
            
            Alert.showAlert(Constants.appName, message: "Are you sure that you want to place a bid?", from: self) { yesAction in
                self.placeBid()
            } negativeHandler: { noAction in
                
            }
        }
        
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func onClickCancelBid(_ sender: Any) {
        if let _ = bidInfo {
            Alert.showAlert(Constants.appName, message: "Are you sure that you want to cancel this bid?", from: self) { yesAction in
                self.cancelBid()
            } negativeHandler: { noAction in
                
            }
        }
        else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    private func onClickMoreInfo(_ sender: UIButton) {
        isMoreInfo = !isMoreInfo
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension BidDetailController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BidMoreInfoCell", for: indexPath) as! BidMoreInfoCell
        
        cell.expandButton.addTarget(self, action: #selector(onClickMoreInfo(_:)), for: .touchUpInside)
        if isMoreInfo {
            cell.expandButton.isSelected = true
            cell.infoView.isHidden = false
            cell.infoViewHeight.constant = 140
        }
        else {
            cell.expandButton.isSelected = false
            cell.infoView.isHidden = true
            cell.infoViewHeight.constant = 0
        }
        cell.layoutIfNeeded()
        
        if let loadInfo = loadInfo {
            cell.showLoadInfo(loadInfo)
        }
        
        cell.showPriceInfo(bidPrice: bidPrice)
        
        return cell
    }
    
}
