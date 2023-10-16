//
//  SplashViewController.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit
import FirebaseAuth
import MBProgressHUD

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                // Logged out
                print("================== user logged out")
            }
            else { // Logged in
                print("================== user logged in")
            }
        }
        
        FirebaseService.listenUserInfo { profileStatus, error in
            if UserDefaults.standard.bool(forKey: Constants.prefFirstLaunched) {
                UserDefaults.standard.set(false, forKey: Constants.prefFirstLaunched)
                return
            }
            
            if let error = error {
                print("\(error.localizedDescription)")
            }
            if let status = profileStatus {
                if status == .approved {
                    DispatchQueue.main.async {
                        self.presentMainTab()
                    }
                }
                else if status == .blocked || status == .deleted {
                    FirebaseService.logout()
                    DispatchQueue.main.async {
                        self.presentLogin()
                    }
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: Constants.notifyPresentDashboard), object: nil, queue: OperationQueue.main) { notification in
            self.presentMainTab()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: Constants.notifyPresentLogin), object: nil, queue: OperationQueue.main) { notification in
            self.presentLogin()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        perform(#selector(presentNext), with: nil, afterDelay: 0.4)
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
    
    @objc
    private func presentNext() {
        if FirebaseService.isLoggedIn {
            MBProgressHUD.showAdded(to: view, animated: true)
            FirebaseService.getUserInfo { user in
                MBProgressHUD.hide(for: self.view, animated: true)
                if user.statusValue() == .approved {
                    self.presentMainTab()
                }
                else {
                    var errMsg = "Something went wrong.\nPlease contact our administrator!"
                    if user.statusValue() == .blocked {
                        errMsg = "Your account has been blocked.\n\nWe've detected suspicious activity on your account. Please contact our administrator."
                    }
                    else if user.statusValue() == .pending {
                        errMsg = "Please wait while we approve your registration.\n\nThanks so much!"
                    }
                    else if user.statusValue() == .blocked {
                        errMsg = "Your account has been deleted. Please create a new one."
                    }
                    
                    Alert.showAlert(Constants.appName, message: errMsg, from: self) { action in
                        if user.statusValue() == .pending {
                            // Wait until approved
                        }
                        else if user.statusValue() == .deleted || user.statusValue() == .blocked {
                            FirebaseService.logout()
                            DispatchQueue.main.async {
                                self.presentLogin()
                            }
                        }
                    }
                }
            }
        }
        else {
            presentLogin()
        }
    }
    
    private func presentLogin() {
        if let presented = self.presentedViewController {
            presented.dismiss(animated: true) {
                self.presentLogin()
            }
        }
        else {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
                return
            }
            let nav = BaseNavigationController(rootViewController: vc)
            nav.modalTransitionStyle = .crossDissolve
            nav.modalPresentationStyle = .overCurrentContext
            present(nav, animated: true, completion: nil)
        }
    }
    
    private func presentMainTab() {
        if let presented = self.presentedViewController {
            presented.dismiss(animated: true) {
                self.presentMainTab()
            }
        }
        else {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabController") as? MainTabController else {
                return
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: true, completion: nil)
        }
    }
    

}
