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
    
    func setShadow(
        shadowColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.08),
        background: UIColor = UIColor(named: "White")!
    ) {
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = Constants.cornerRadius1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.cornerRadius = Constants.cornerRadius1
        backgroundColor = background
    }
    
    func setGradientBackground() {
        let layer0 = CAGradientLayer()
        layer0.colors = [
            UIColor(red: 0.094, green: 0.282, blue: 0.369, alpha: 1).cgColor,
            UIColor(red: 0.059, green: 0.141, blue: 0.224, alpha: 1).cgColor
        ]
        layer0.locations = [0, 1]
        layer0.startPoint = CGPoint(x: 0.25, y: 0.5)
        layer0.endPoint = CGPoint(x: 0.75, y: 0.5)
//        layer0.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 0.77, c: -0.77, d: 0, tx: 0.89, ty: 0))
        layer0.bounds = bounds.insetBy(dx: -0.5*bounds.size.width, dy: -0.5*bounds.size.height)
        layer0.position = center
        
        layer.addSublayer(layer0)
    }
    
    
    
}

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        
        return result

    }
    
}

extension UIImage {
    
    public class func defaultUserPhoto() -> UIImage {
        return UIImage(named: "PhotoPlaceholder")!
    }
    
}

extension UITextField {
    
    func setPlaceholder(_ placeholder: String, color: UIColor = UIColor(named: "TextLightGray")!) {
        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
    
}
