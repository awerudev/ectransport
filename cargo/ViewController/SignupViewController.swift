//
//  SignupViewController.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit
import AFViewShaker
import MBProgressHUD

class SignupViewController: UIViewController {
    
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var lengthView: UIView!
    @IBOutlet weak var widthView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var confirmPassView: UIView!
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var lengthText: UITextField!
    @IBOutlet weak var widthText: UITextField!
    @IBOutlet weak var heightText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPassText: UITextField!
    
    @IBOutlet weak var createButton: UIButton!
    
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
        nameView.setBorder()
        emailView.setBorder()
        phoneView.setBorder()
        lengthView.setBorder()
        widthView.setBorder()
        heightView.setBorder()
        passwordView.setBorder()
        confirmPassView.setBorder()
        
        nameText.delegate = self
        nameText.keyboardType = .default
        nameText.autocapitalizationType = .words
        nameText.returnKeyType = .next
        
        emailText.delegate = self
        emailText.keyboardType = .emailAddress
        emailText.returnKeyType = .next
        
        phoneText.delegate = self
        phoneText.keyboardType = .phonePad
        phoneText.returnKeyType = .next
        
        lengthText.delegate = self
        lengthText.keyboardType = .numbersAndPunctuation
        lengthText.returnKeyType = .next
        
        widthText.delegate = self
        widthText.keyboardType = .numbersAndPunctuation
        widthText.returnKeyType = .next
        
        heightText.delegate = self
        heightText.keyboardType = .numbersAndPunctuation
        heightText.returnKeyType = .next
        
        passwordText.delegate = self
        passwordText.isSecureTextEntry = true
        passwordText.returnKeyType = .next
        
        confirmPassText.delegate = self
        confirmPassText.isSecureTextEntry = true
        confirmPassText.returnKeyType = .go
        
        createButton.layer.cornerRadius = createButton.frame.size.height / 2
        createButton.clipsToBounds = true
    }
    
    private func validate() -> Bool {
        var arrViews = [UIView]()
        if let value = nameText.text, value.isEmpty {
            arrViews.append(nameView)
        }
        if let value = emailText.text {
            if value.isEmpty {
                arrViews.append(emailView)
            }
            else if !value.isValidEmail() {
                arrViews.append(emailView)
            }
        }
        if let value = lengthText.text {
            if value.isEmpty {
                arrViews.append(lengthView)
            }
            else if Double(value) == nil {
                arrViews.append(lengthView)
            }
        }
        if let value = widthText.text {
            if value.isEmpty {
                arrViews.append(widthView)
            }
            else if Double(value) == nil {
                arrViews.append(widthView)
            }
        }
        if let value = heightText.text {
            if value.isEmpty {
                arrViews.append(heightView)
            }
            else if Double(value) == nil {
                arrViews.append(heightView)
            }
        }
        if let value = passwordText.text {
            if value.isEmpty {
                arrViews.append(passwordView)
            }
            else if value.count < 6 {
                arrViews.append(passwordView)
            }
        }
        if let value = confirmPassText.text {
            if value.isEmpty {
                arrViews.append(confirmPassView)
            }
            else if value != passwordText.text {
                arrViews.append(confirmPassView)
            }
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
    
    @IBAction func onClickSignup(_ sender: UIButton) {
        guard validate() else {
            return
        }
        
        let name = nameText.text ?? ""
        let email = emailText.text ?? ""
        let phone = phoneText.text ?? ""
        let length = Double(lengthText.text ?? "") ?? 0
        let width = Double(widthText.text ?? "") ?? 0
        let height = Double(heightText.text ?? "") ?? 0
        let password = passwordText.text ?? ""
        
        MBProgressHUD.showAdded(to: view, animated: true)
        FirebaseService.signupWith(email: email, password: password) { (result, error) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let error = error {
                Alert.showAlert("Error", message: error.localizedDescription, from: self, handler: nil)
                return
            }
            
            if let result = result {
                // Save User Info
                var user = User()
                user.id = result.user.uid
                user.name = name
                user.email = email
                user.phone = phone
                user.vehicle.length = length
                user.vehicle.width = width
                user.vehicle.height = height
                
                FirebaseService.saveUserInfo(user: user) { error in
                    if let error = error {
                        print("====== saveUserInfo Error: \(error.localizedDescription)")
                    }
                    Alert.showAlert(Constants.appName, message: "Your account was created successfully!", from: self) { action in
                        FirebaseService.logout()
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func onClickLogin(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UITextFieldDelegate

extension SignupViewController: UITextFieldDelegate {
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == nameText {
            emailText.becomeFirstResponder()
        }
        else if textField == emailText {
            phoneText.becomeFirstResponder()
        }
        else if textField == phoneText {
            lengthText.becomeFirstResponder()
        }
        else if textField == lengthText {
            widthText.becomeFirstResponder()
        }
        else if textField == widthText {
            heightText.becomeFirstResponder()
        }
        else if textField == heightText {
            passwordText.becomeFirstResponder()
        }
        else if textField == passwordText {
            confirmPassText.becomeFirstResponder()
        }
        else if textField == confirmPassText {
            onClickSignup(createButton)
        }
        
        return true
    }
    
}
