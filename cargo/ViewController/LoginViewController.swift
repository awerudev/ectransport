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
            
            FirebaseService.getUserInfo()
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notifyPresentDashboard), object: nil)
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
