//
//  ProfileViewController.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit
import SDWebImage
import GooglePlaces

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var addressInputView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var loadsLabel: UILabel!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var editProfileButton: UIButton!
    
    private var myBids = [BidInfo]()
    
    // MARK: - Method

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: Constants.notifyProfileUpdated), object: nil, queue: OperationQueue.main) { notification in
            self.showUserInfo()
        }
        
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        getMyBids()
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
        addressInputView.setBorder(UIColor(red: 0.225, green: 0.751, blue: 0.992, alpha: 0.2))
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        
        // Logout Button
        logoutButton.setBorder(UIColor(named: "ButtonBorderRed")!)
        
        // User Info
        userImage.setBorder(UIColor(named: "White")!, cornerRadius: Constants.cornerRadius1)
        
        addressText.setPlaceholder("Enter Address")
        addressText.delegate = self
        
        editProfileButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.1)
        editProfileButton.layer.cornerRadius = Constants.cornerRadius0
        editProfileButton.clipsToBounds = true
        
        // --------------------
        
        showUserInfo()
    }
    
    private func showUserInfo() {
        let user = User.user()
        nameLabel.text = user.name
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        loadsLabel.text = "0 Loads"
        addressText.text = user.address
        
        if !user.photo.isEmpty {
            userImage.sd_setImage(with: URL(string: user.photo), placeholderImage: UIImage.defaultUserPhoto(), options: .continueInBackground) { image, error, cacheType, url in
                
            }
        }
    }
    
    private func presentAddressAutoComplete() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(
            rawValue: GMSPlaceField.name.rawValue | GMSPlaceField.placeID.rawValue | GMSPlaceField.coordinate.rawValue | GMSPlaceField.addressComponents.rawValue | GMSPlaceField.formattedAddress.rawValue
        )
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.types = ["address"]
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    private func getMyBids() {
        FirebaseService.getLastBids { items, error in
            self.myBids = []
            self.myBids.append(contentsOf: items)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Action

    @IBAction func onClickEditProfile(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileController") as? EditProfileController else {
            return
        }
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
    }
    
    @IBAction func onClickLogout(_ sender: Any) {
        Alert.showAlert(Constants.appName, message: "Are you sure that you want to log out?", from: self) { yesAction in
            FirebaseService.logout()
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notifyPresentLogin), object: nil)
        } negativeHandler: { noAction in
            
        }
    }
    
    @IBAction func onClickViewAll(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ActiveLoadController") as? ActiveLoadController else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - GMSAutocompleteViewControllerDelegate

extension ProfileViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        viewController.dismiss(animated: true)
        
        addressText.text = place.formattedAddress
        
        var user = User.user()
        user.address = place.formattedAddress ?? ""
        user.latitude = place.coordinate.latitude
        user.longitude = place.coordinate.longitude
        
        user.save(sync: true)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        viewController.dismiss(animated: true)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true)
    }
    
}

// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == addressText {
            presentAddressAutoComplete()
        }
        return true
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileLoadCell", for: indexPath) as! ProfileLoadCell
        
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
