//
//  HomeViewController.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit
import MapKit
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var topView: GradientView!    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         
        topViewHeight.constant = view.safeAreaInsets.top + 61
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
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
        // MapView
        mapView.layer.cornerRadius = Constants.cornerRadius1
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        
        userImage.setBorder(UIColor(named: "White")!)
        
        let user = User.user()
        nameLabel.text = user.name
        if !user.photo.isEmpty {
            userImage.sd_setImage(with: URL(string: user.photo), placeholderImage: UIImage.defaultUserPhoto(), options: .continueInBackground) { image, error, cacheType, url in
                
            }
        }
    }
    
    private func presentArriveConfirm() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ArriveConfirmController") as? ArriveConfirmController else {
            return
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    private func presentLoadInfo() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "LoadInfoController") as? LoadInfoController else {
            return
        }
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
    }
    
    // MARK: - Action
    
    @objc
    private func onClickAction(_ sender: UIButton) {
        presentArriveConfirm()
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeAddressTableCell", for: indexPath) as! HomeAddressTableCell
            
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNoLoadTableCell", for: indexPath) as! HomeNoLoadTableCell
            
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeLoadTableCell", for: indexPath) as! HomeLoadTableCell
            
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTransitTableCell", for: indexPath) as! HomeTransitTableCell
            
            cell.actionButton.addTarget(self, action: #selector(onClickAction(_:)), for: .touchUpInside)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


