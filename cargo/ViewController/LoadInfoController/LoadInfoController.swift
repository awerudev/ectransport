//
//  LoadInfoController.swift
//  cargo
//
//  Created by Apple on 9/26/23.
//

import UIKit

class LoadInfoController: UIViewController {
    
    @IBOutlet weak var piecesView: UIView!
    @IBOutlet weak var pieceScheduledView: UIView!
    @IBOutlet weak var pieceActualView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var weightScheduledView: UIView!
    @IBOutlet weak var weightActualView: UIView!
    @IBOutlet weak var bolNumberView: UIView!
    @IBOutlet weak var noMatchButton: UIButton!
    @IBOutlet weak var yesMatchButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    
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
        // Pieces
        piecesView.setShadow()
        pieceScheduledView.setBorder(UIColor(named: "ViewBorder")!)
        pieceActualView.setBorder(UIColor(named: "InputBorder")!)
        
        // Total Weight
        weightView.setShadow()
        weightScheduledView.setBorder(UIColor(named: "ViewBorder")!)
        weightActualView.setBorder(UIColor(named: "InputBorder")!)
        
        // BOL Number
        bolNumberView.setBorder(UIColor(named: "InputBorder")!)
        
        // BOL Match Address
        noMatchButton.isSelected = false
        noMatchButton.backgroundColor = UIColor(named: "ViewBackground")
        noMatchButton.setBorder(UIColor(named: "ViewBorder")!)
        
        yesMatchButton.isSelected = true
        yesMatchButton.backgroundColor = UIColor(named: "InputBackground")
        yesMatchButton.setBorder(UIColor(named: "InputBorder")!)
        
        // Continue Button
        continueButton.layer.cornerRadius = continueButton.frame.size.height / 2
        continueButton.clipsToBounds = true
    }

}
