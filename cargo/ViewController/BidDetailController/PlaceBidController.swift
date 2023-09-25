//
//  PlaceBidController.swift
//  cargo
//
//  Created by Apple on 9/24/23.
//

import UIKit

class PlaceBidController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var totalPriceView: UIView!
    @IBOutlet weak var totalPriceText: UITextField!
    @IBOutlet weak var priceMileView: UIView!
    @IBOutlet weak var priceMileText: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var placeButton: UIButton!
    
    /// 360
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    private let INIT_HEI: CGFloat = 360
    private var currentHei: CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showContentViewFromBottom(true)
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
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapBackground(_:))))
        
        contentViewHeight.constant = 0
        
        // Gestures
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveOnContentView(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        contentView.addGestureRecognizer(panGesture)
        contentView.isUserInteractionEnabled = true
        
        // Input Fields
        totalPriceView.setBorder()
        priceMileView.setBorder()
        
        totalPriceText.keyboardType = .numberPad
        priceMileText.keyboardType = .numberPad
        
        cancelButton.setBorder(UIColor(red: 0.837, green: 0.865, blue: 0.883, alpha: 1))
        placeButton.setBorder(UIColor(named: "TextGray")!)
    }
    
    private func hideContentViewWithCompletion(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            self.contentViewHeight.constant = 0
            self.view.layoutIfNeeded()
        }) { (finish) in
            if let completion = completion {
                completion(finish)
            }
        }
    }
    
    private func showContentViewFromBottom(_ bottom: Bool) {
        var startValue: CGFloat = 0
        if bottom {
            startValue = INIT_HEI + 20
        }
        else {
            startValue = INIT_HEI - 20
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.contentViewHeight.constant = startValue
            self.view.layoutIfNeeded()
        }) { (finish) in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.contentViewHeight.constant = self.INIT_HEI
                self.view.layoutIfNeeded()
            }) { (finish) in
                self.currentHei = self.INIT_HEI
            }
        }
    }
    
    private func showFullContentView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.contentViewHeight.constant = Constants.screenHei + 10
            self.view.layoutIfNeeded()
        }) { (finish) in
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
                self.contentViewHeight.constant = Constants.screenHei - 44
                self.view.layoutIfNeeded()
            }) { (finish) in
                self.currentHei = Constants.screenHei
            }
        }
    }
    
    // MARK: - Action
    
    @IBAction func onClickCancel(_ sender: Any) {
        hideContentViewWithCompletion { (finish) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    private func onTapBackground(_ sender: Any) {
        hideContentViewWithCompletion { (finish) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    private func moveOnContentView(_ sender: UIPanGestureRecognizer) {
        guard let senderView = sender.view else {
            return
        }
        view.bringSubviewToFront(senderView)
        let translatePoint = sender.translation(in: senderView.superview)
        contentViewHeight.constant = currentHei - translatePoint.y
        view.layoutIfNeeded()
        
        if sender.state == UIGestureRecognizer.State.ended {
            
            let velocityY = 0.2 * sender.velocity(in: self.view).y
            var finalY = self.view.frame.size.height - currentHei + translatePoint.y + velocityY
            
            if finalY < 50 { // To avoid the status bar
                finalY = 50
            }
            else if finalY > self.view.frame.size.height {
                finalY = self.view.frame.size.height
            }
            
            let animationDuration = abs(velocityY) * 0.0002 + 0.2
            UIView.animate(withDuration: TimeInterval(animationDuration), delay: 0, options: .curveEaseOut) {
                self.contentViewHeight.constant = self.view.frame.size.height - finalY
                self.view.layoutIfNeeded()
            } completion: { finish in
                self.didFinishedContentViewMovement()
            }
        }
    }
    
    @objc
    private func didFinishedContentViewMovement() {
        let criteria: CGFloat = Constants.screenHei * 4 / 5.0
        if contentViewHeight.constant >= criteria {
            showFullContentView()
        }
        else if contentViewHeight.constant >= INIT_HEI {
            showContentViewFromBottom(false)
        }
        else if contentViewHeight.constant >= 20 {
            showContentViewFromBottom(true)
        }
        else {
            hideContentViewWithCompletion { (finish) in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    
}
