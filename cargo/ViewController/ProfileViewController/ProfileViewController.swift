//
//  ProfileViewController.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var addressInputView: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var loadsLabel: UILabel!
    
    // MARK: - Method

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        
        userImage.setBorder(UIColor(named: "White")!, cornerRadius: Constants.cornerRadius1)
        
        let user = User.user()
        nameLabel.text = user.name
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        loadsLabel.text = "0 Loads"
        
        if !user.photo.isEmpty {
            userImage.sd_setImage(with: URL(string: user.photo), placeholderImage: UIImage.defaultUserPhoto(), options: .continueInBackground) { image, error, cacheType, url in
                
            }
        }
    }
    
    // MARK: - Action

    @IBAction func onClickLogout(_ sender: Any) {
        Alert.showAlert(Constants.appName, message: "Are you sure that you want to log out?", from: self) { yesAction in
            FirebaseService.logout()
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notifyPresentLogin), object: nil)
        } negativeHandler: { noAction in
            
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileLoadCell", for: indexPath) as! ProfileLoadCell
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
