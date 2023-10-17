//
//  ActiveLoadController.swift
//  cargo
//
//  Created by Apple on 10/15/23.
//

import UIKit

class ActiveLoadController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    private var myBids = [BidInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initLayout()
        
        getMyBids()
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
        navigationItem.title = "Active Loads"
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
    }
    
    private func getMyBids() {
        FirebaseService.getBids { items, error in
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            
            self.myBids = []
            self.myBids.append(contentsOf: items)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Action
    
    @objc
    private func onRefresh(_ sender: UIRefreshControl) {
        getMyBids()
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ActiveLoadController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBids.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveLoadCell", for: indexPath) as! ActiveLoadCell
        
        if myBids.count > indexPath.row {
            let bidInfo = myBids[indexPath.row]
            cell.showBidInfo(bidInfo)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if myBids.count > indexPath.row {
            let bidInfo = myBids[indexPath.row]
            guard let vc = storyboard?.instantiateViewController(withIdentifier: "BidDetailController") as? BidDetailController else {
                return
            }
            vc.loadInfo = bidInfo.toLoadData()
            vc.bidInfo = bidInfo
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
