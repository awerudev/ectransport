//
//  BidsViewController.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit

class BidsViewController: UIViewController {

    @IBOutlet weak var topView: GradientView!    
    @IBOutlet weak var addressInputView: UIView!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         
        topViewHeight.constant = view.safeAreaInsets.top + 61
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
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
        
        // Address View
        addressInputView.setBorder(UIColor(red: 0.225, green: 0.751, blue: 0.992, alpha: 0.2))
        
        addressText.setPlaceholder("Enter Address")
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: - Action
    
    @objc
    private func onClickSeeDetails(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "BidDetailController") as? BidDetailController else {
            return
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension BidsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BidTableCell", for: indexPath) as! BidTableCell
        
        cell.detailButton.tag = indexPath.row
        cell.detailButton.addTarget(self, action: #selector(onClickSeeDetails(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
