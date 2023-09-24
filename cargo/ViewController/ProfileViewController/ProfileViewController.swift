//
//  ProfileViewController.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var addressInputView: UIView!
    
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
    }
    
    // MARK: - Action

}
