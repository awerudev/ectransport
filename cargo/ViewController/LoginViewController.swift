//
//  LoginViewController.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit
import AFViewShaker
import MBProgressHUD
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
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
        emailView.setBorder()
        passwordView.setBorder()
        
        emailText.keyboardType = .emailAddress
        emailText.delegate = self
        emailText.returnKeyType = .next
        passwordText.isSecureTextEntry = true
        passwordText.delegate = self
        passwordText.returnKeyType = .go
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        loginButton.clipsToBounds = true
    }
    
    private func validate() -> Bool {
        var arrViews = [UIView]()
        if let value = emailText.text {
            if value.isEmpty || !value.isValidEmail() {
                arrViews.append(emailView)
            }
        }
        if let value = passwordText.text, value.isEmpty {
            arrViews.append(passwordText)
        }
        
        if arrViews.count > 0 {
            if let shaker = AFViewShaker(viewsArray: arrViews) {
                shaker.shake()
            }
            return false
        }
        
        return true
    }
    
    // MARK: - Action
    
    @IBAction func onClickLogin(_ sender: UIButton) {
        guard validate() else {
            return
        }
        
        let email = emailText.text ?? ""
        let password = passwordText.text ?? ""
        
        MBProgressHUD.showAdded(to: view, animated: true)
        FirebaseService.loginWith(email: email, password: password) { error in
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if let error = error {
                Alert.showAlert("Error", message: error.localizedDescription, from: self, handler: nil)
                return
            }
        
            MBProgressHUD.showAdded(to: self.view, animated: true)
            FirebaseService.getUserInfo { user in
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if user.statusValue() == .approved {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notifyPresentDashboard), object: nil)
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
                            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notifyListenUserInfo), object: nil, userInfo: ["screen": ""])
                            self.dismiss(animated: true)
                        }
                        else if user.statusValue() == .deleted || user.statusValue() == .blocked {
                            FirebaseService.logout()                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func onClickSignup(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as? SignupViewController else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailText {
            passwordText.becomeFirstResponder()
        }
        else if textField == passwordText {
            onClickLogin(loginButton)
        }
        return true
    }
    
}
