//
//  Alert.swift
//  cargo
//
//  Created by Apple on 9/26/23.
//

import UIKit

class Alert: NSObject {

    open class func showAlert(_ title: String?, message: String?, actionTitle: String? = "OK", from: UIViewController, handler: ((UIAlertAction) -> Void)?) {
            
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle ?? "OK", style: .default, handler: handler))
        from.present(alert, animated: true, completion: nil)
    }
    
    open class func showAlert(_ title: String?, message: String?, positiveTitle: String? = "Yes", negativeTitle: String? = "No", from: UIViewController, positiveHandler: ((UIAlertAction) -> Void)?, negativeHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: positiveTitle ?? "Yes", style: .default, handler: positiveHandler))
        alert.addAction(UIAlertAction(title: negativeTitle ?? "No", style: .cancel, handler: negativeHandler))
        from.present(alert, animated: true, completion: nil)
    }

}
