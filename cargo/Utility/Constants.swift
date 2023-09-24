//
//  Constants.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit

class Constants: NSObject {
    
    // MARK: - UI Layout
    /// 8
    static let cornerRadius0: CGFloat = 8
    /// 16
    static let cornerRadius1: CGFloat = 16
    
    static var safeAreaInsets: UIEdgeInsets {
        return AppDelegate.shared.window?.safeAreaInsets ?? UIEdgeInsets.zero
    }
    
    // MARK: - Notification Center
    
    static let notifyPresentDashboard = "present_dashboard"

}
