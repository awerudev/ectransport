//
//  ArriveConfirmController.swift
//  cargo
//
//  Created by Apple on 9/26/23.
//

import UIKit

class ArriveConfirmController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presentContentView()
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
        // Background View
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapBackgroundView(_:)))
        backgroundView.addGestureRecognizer(tapGesture)
        
        // Content View
        contentView.layer.cornerRadius = Constants.cornerRadius1
        contentView.clipsToBounds = true
        
        // Bottom Buttons
        noButton.setBorder(UIColor(named: "ViewBorder")!)
        yesButton.setBorder(UIColor(named: "TextGray")!)
    }
    
    private func presentContentView() {
        contentView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.contentView.alpha = 1.0
            self.contentView.transform = .identity
        }
            , completion: { (finished) in
                
        })
    }
    
    // MARK: - Action
    
    @objc
    private func onTapBackgroundView(_ sender: UIView) {
        dismiss(animated: true)
    }

}
