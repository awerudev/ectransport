//
//  PlaceBidController.swift
//  cargo
//
//  Created by Apple on 9/24/23.
//

import UIKit
import AFViewShaker

class PlaceBidController: UIViewController {
    
    var onPlacePrices: ((Double, VehicleDimension, Date) -> Void)?

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var totalPriceView: UIView!
    @IBOutlet weak var totalPriceText: UITextField!
    @IBOutlet weak var etaView: UIView!
    @IBOutlet weak var etaText: UITextField!
    @IBOutlet weak var lengthView: UIView!
    @IBOutlet weak var lengthText: UITextField!
    @IBOutlet weak var widthView: UIView!
    @IBOutlet weak var widthText: UITextField!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var heightText: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var placeButton: UIButton!
    
    /// 400
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    
    private let INIT_HEI: CGFloat = 400
    private var currentHei: CGFloat = 0
    
    private var etaToPickup = Date()
    
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
        totalPriceText.keyboardType = .numbersAndPunctuation
        
        etaView.setBorder()
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(onDateChanged(_:)), for: .valueChanged)
        etaText.inputView = datePicker
        
        lengthView.setBorder()
        lengthText.keyboardType = .numbersAndPunctuation
        widthView.setBorder()
        widthText.keyboardType = .numbersAndPunctuation
        heightView.setBorder()
        heightText.keyboardType = .numbersAndPunctuation
        
        cancelButton.setBorder(UIColor(named: "ViewBorderThick")!)
        placeButton.setBorder(UIColor(named: "TextGray")!)
        
        let user = User.user()
        lengthText.text = "\(user.vehicle.length)"
        widthText.text = "\(user.vehicle.width)"
        heightText.text = "\(user.vehicle.height)"
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
    
    private func validate() -> Bool {
        var arrViews = [UIView]()
        if let value = totalPriceText.text {
            if value.isEmpty || Double(value) == nil {
                arrViews.append(totalPriceView)
            }
        }
        if let value = etaText.text, value.isEmpty {
            arrViews.append(etaView)
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
        
        if arrViews.count > 0 {
            if let shaker = AFViewShaker(viewsArray: arrViews) {
                shaker.shake()
            }
            return false
        }
        
        return true
    }
    
    // MARK: - Action
    
    @IBAction func onClickPlace(_ sender: Any) {
        guard validate() else {
            return
        }
        
        let totalPrice = Double(totalPriceText.text!) ?? 0
        let length = Double(lengthText.text!) ?? 0
        let width = Double(widthText.text!) ?? 0
        let height = Double(heightText.text!) ?? 0
        
        hideContentViewWithCompletion { finish in
            self.dismiss(animated: true) {
                if let onPlacePrices = self.onPlacePrices {
                    onPlacePrices(
                        totalPrice,
                        VehicleDimension(length: length, width: width, height: height),
                        self.etaToPickup
                    )
                }
            }
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        hideContentViewWithCompletion { (finish) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc
    private func onDateChanged(_ sender: UIDatePicker) {
        etaToPickup = sender.date
        etaText.text = DateFormatter.dateFormat4.string(from: sender.date)
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
