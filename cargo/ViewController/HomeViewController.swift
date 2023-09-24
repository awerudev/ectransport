//
//  HomeViewController.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var topView: GradientView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressInputView: UIView!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var findLoadView: UIView!
    @IBOutlet weak var findLoadButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         
        topViewHeight.constant = view.safeAreaInsets.top + 61
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

        // Address View
        addressView.setBorder(UIColor(named: "ViewBorder")!, width: 1, cornerRadius: Constants.cornerRadius1)
        addressInputView.setBorder()
        
        // Schedule Button
        scheduleButton.setBorder(UIColor(named: "TextGray")!, width: 1, cornerRadius: scheduleButton.frame.size.height / 2) 
//        scheduleButton.clipsToBounds = true
        
        // Find Loads
        findLoadView.setBorder(UIColor(named: "ViewBorder")!, width: 1, cornerRadius: Constants.cornerRadius1)
        findLoadButton.setBorder(UIColor(named: "TextGray")!)
        
        // MapView
        mapView.layer.cornerRadius = Constants.cornerRadius1
    }

}
