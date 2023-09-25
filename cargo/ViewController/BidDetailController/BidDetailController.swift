//
//  BidDetailController.swift
//  cargo
//
//  Created by Apple on 9/24/23.
//

import UIKit

class BidDetailController: UIViewController {

    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var cancelBidButton: UIButton!
    @IBOutlet weak var placeBidButton: UIButton!
    
    
    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
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
        
        cancelBidButton.setBorder(UIColor(red: 0.837, green: 0.865, blue: 0.883, alpha: 1))
        placeBidButton.setBorder(UIColor(named: "TextGray")!)
    }
    
    // MARK: - Action
    
    @IBAction func onClickPlaceBid(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "PlaceBidController") as? PlaceBidController else {
            return
        }
        
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
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
        
        
        return cell
    }
    
}
