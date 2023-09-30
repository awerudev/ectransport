//
//  MainTabController.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit

class MainTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tabBar.isTranslucent = false
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: Constants.notifyPresentBids), object: nil, queue: OperationQueue.main) { notification in
            self.selectedIndex = 1
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
