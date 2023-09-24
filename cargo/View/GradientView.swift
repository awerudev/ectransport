//
//  GradientView.swift
//  cargo
//
//  Created by Apple on 9/20/23.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBInspectable var startColor: UIColor = .black {
        didSet {
            updateColors()
        }
    }
    
    @IBInspectable var endColor: UIColor = .white {
        didSet {
            updateColors()
        }
    }
    
    override class var layerClass: AnyClass { CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()                
    }
    
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        updateColors()
    }
    
}
