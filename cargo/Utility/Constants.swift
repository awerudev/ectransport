//
//  Constants.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit

class Constants: NSObject {
    
    static let appName = "ECT CARGO"
    
    static let googleAPIKey = "AIzaSyCc60YVL8fhVeQk013kntclJiBCZ53xKkg"
    
    // MARK: - UI Layout
    class var screenHei: CGFloat {
        return UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height ? UIScreen.main.bounds.size.height: UIScreen.main.bounds.size.width
    }
    
    class var screenWid: CGFloat {
        return UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height ? UIScreen.main.bounds.size.height: UIScreen.main.bounds.size.width
    }
    /// 8
    static let cornerRadius0: CGFloat = 8
    /// 16
    static let cornerRadius1: CGFloat = 16
    
    static var safeAreaInsets: UIEdgeInsets {
        return AppDelegate.shared.window?.safeAreaInsets ?? UIEdgeInsets.zero
    }
    
    // MARK: - Standard UserDefault
    
    static let prefCurrentUser = "current_user"
    
    // MARK: - Notification Center
    
    static let notifyPresentDashboard = "present_dashboard"
    static let notifyPresentLogin = "present_login"
    static let notifyProfileUpdated = "profile_updated"

}
