//
//  MyAnnotationView.swift
//  cargo
//
//  Created by Apple on 10/11/23.
//

import Foundation
import CoreLocation
import MapKit

class MyAnnotationView: MKPinAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        canShowCallout = true
//        if let pinColor = annotation?.subtitle {
//            switch pinColor {
//            case "Red":
//                pinTintColor = .red
//            case "Blue":
//                pinTintColor = .blue
//            case "Green":
                pinTintColor = .green
//            default:
//                break
//            }
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
