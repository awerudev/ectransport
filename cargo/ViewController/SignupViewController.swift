//
//  SignupViewController.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit
import AFViewShaker

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
        lengthText.keyboardType = .numberPad
        lengthText.returnKeyType = .next
        
        widthText.delegate = self
        widthText.keyboardType = .numberPad
        widthText.returnKeyType = .next
        
        heightText.delegate = self
        heightText.keyboardType = .numberPad
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
    
    // MARK: - Action
    
    @IBAction func onClickSignup(_ sender: UIButton) {
        
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
