//
//  EditProfileController.swift
//  cargo
//
//  Created by Apple on 9/26/23.
//

import UIKit
import SDWebImage
import CoreServices
import AFViewShaker
import MBProgressHUD

class EditProfileController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var penImage: UIImageView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var lengthView: UIView!
    @IBOutlet weak var lengthText: UITextField!
    @IBOutlet weak var widthView: UIView!
    @IBOutlet weak var widthText: UITextField!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var heightText: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK: - Method

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initLayout()
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
        userImage.setBorder(UIColor(named: "TextGray")!, width: 1, cornerRadius: Constants.cornerRadius1)
//        penImage.setShadow(background: UIColor.clear)
        
        nameView.setBorder()
        nameText.keyboardType = .default
        nameText.autocapitalizationType = .words
        
        emailView.setBorder()
        emailText.isEnabled = false
        
        phoneView.setBorder()
        phoneText.keyboardType = .phonePad
        
        lengthView.setBorder()
        lengthText.keyboardType = .numbersAndPunctuation
        widthView.setBorder()
        widthText.keyboardType = .numbersAndPunctuation
        heightView.setBorder()
        heightText.keyboardType = .numbersAndPunctuation
                
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
        submitButton.clipsToBounds = true
        
        // - User Info
        let user = User.user()
        nameText.text = user.name
        emailText.text = user.email
        phoneText.text = user.phone
        lengthText.text = "\(user.vehicle.length)"
        widthText.text = "\(user.vehicle.width)"
        heightText.text = "\(user.vehicle.height)"
        
        if !user.photo.isEmpty {
            userImage.sd_setImage(with: URL(string: user.photo), placeholderImage: UIImage.defaultUserPhoto(), options: .continueInBackground) { image, error, cacheType, url in
                
            }
        }
    }
    
    private func presentImagePicker(fromCamera: Bool) {
        let pickerC = UIImagePickerController()
//        pickerC.navigationBar.tintColor = UIColor.white
//        pickerC.navigationBar.barTintColor = UIColor.appOrange1
//        pickerC.navigationBar.shadowImage = UIImage()
//        pickerC.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        pickerC.delegate = self
        pickerC.allowsEditing = true
        pickerC.mediaTypes = [kUTTypeImage as String]
        
        if fromCamera {
            pickerC.sourceType = .camera
        }
        else {
            pickerC.sourceType = .photoLibrary
        }
        present(pickerC, animated: true, completion: nil)
    }
    
    private func validate() -> Bool {
        var arrViews = [UIView]()
        if let value = nameText.text, value.isEmpty {
            arrViews.append(nameView)
        }
        if let value = lengthText.text {
            if value.isEmpty || Double(value) == nil {
                arrViews.append(lengthView)
            }
        }
        if let value = widthText.text, value.isEmpty {
            if value.isEmpty || Double(value) == nil {
                arrViews.append(widthView)
            }
        }
        if let value = heightText.text, value.isEmpty {
            if value.isEmpty || Double(value) == nil {
                arrViews.append(heightView)
            }
        }
        
        return true
    }
    
    private func uploadImage(_ imageData: Data) {
        FirebaseService.uploadUserPhoto(imageData) { urlString, error in
            if let urlString = urlString {
                var user = User.user()
                user.photo = urlString
                user.save(sync: true)
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notifyProfileUpdated), object: nil)
            }
        }
    }

    
    // MARK: - Action

    @IBAction func onClickPhoto(_ sender: Any) {
        // Present Option Alert Sheet
        let alertC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertC.addAction(UIAlertAction(title: "Choose from camera roll", style: .default, handler: { (action) in
            self.presentImagePicker(fromCamera: false)
        }))
        alertC.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { (action) in
            self.presentImagePicker(fromCamera: true)
        }))
        alertC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        if let popover = alertC.popoverPresentationController {
            popover.sourceRect = self.penImage.frame
            popover.sourceView = self.penImage
        }
        present(alertC, animated: true, completion: nil)
    }
    
    @IBAction func onClickSubmit(_ sender: Any) {
        guard validate() else {
            return
        }
        
        var user = User.user()
        user.name = nameText.text ?? ""
        user.phone = phoneText.text ?? ""
        user.vehicle.length = Double(lengthText.text ?? "") ?? 0
        user.vehicle.width = Double(widthText.text ?? "") ?? 0
        user.vehicle.height = Double(heightText.text ?? "") ?? 0
        
        MBProgressHUD.showAdded(to: view, animated: true)
        FirebaseService.saveUserInfo(user: user) { error in
            MBProgressHUD.hide(for: self.view, animated: true)
            user.save()
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notifyProfileUpdated), object: nil)
            Alert.showAlert(Constants.appName, message: "Your profile has been updated successfully!", from: self, handler: nil)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if info[.mediaType] as! CFString == kUTTypeImage {
            var image = info[.editedImage] as? UIImage
            if image == nil {
                image = info[.originalImage] as? UIImage
            }
            if image == nil {
                return
            }
            userImage.image = image
            
            let imageData = image?.pngData()
            uploadImage(imageData!)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
