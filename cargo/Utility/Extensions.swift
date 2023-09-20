//
//  Extensions.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import Foundation
import UIKit


extension UIView {
    
    func setBorder(_ color: UIColor = UIColor(named: "InputBorder")!, width: CGFloat = 1, cornerRadius: CGFloat? = nil) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        
        if let value = cornerRadius {
            layer.cornerRadius = value
        }
        else {
            layer.cornerRadius = frame.height / 2
        }
    }
    
}

