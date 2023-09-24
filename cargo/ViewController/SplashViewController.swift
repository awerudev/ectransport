//
//  SplashViewController.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: Constants.notifyPresentDashboard), object: nil, queue: OperationQueue.main) { notification in
            self.presentMainTab()
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
        presentLogin()
    }
    
    private func presentLogin() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            return
        }
        let nav = BaseNavigationController(rootViewController: vc)
        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .overCurrentContext
        present(nav, animated: true, completion: nil)
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
