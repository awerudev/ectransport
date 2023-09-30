//
//  BidsViewController.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit
import GooglePlaces

class BidsViewController: UIViewController {

    @IBOutlet weak var topView: GradientView!    
    @IBOutlet weak var addressInputView: UIView!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    private var pickupAddr: String = ""
    private var pickupCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    private var lastLoadID: Int = 0
    private var loadList = [LoadData]()
    
    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initLayout()
        
        getLoads()
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
        addressText.delegate = self
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
    }
    
    private func presentAddressAutoComplete() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(
            rawValue: GMSPlaceField.name.rawValue | GMSPlaceField.placeID.rawValue | GMSPlaceField.coordinate.rawValue | GMSPlaceField.addressComponents.rawValue | GMSPlaceField.formattedAddress.rawValue
        )
        autocompleteController.placeFields = fields

        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.types = ["address"]
        autocompleteController.autocompleteFilter = filter

        // Display the autocomplete view controller.
        present(autocompleteController, animated: true, completion: nil)
    }
    
    private func getLoads() {
        if lastLoadID == 0 {
            refreshControl.beginRefreshing()
        }
        FirebaseService.getLoads(lastLoadID: lastLoadID) { items, error in
            self.refreshControl.endRefreshing()
            
            if self.lastLoadID == 0 {
                self.loadList = []
            }
            self.loadList.append(contentsOf: items)
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Action
    
    @objc
    private func onRefresh(_ sender: UIRefreshControl) {
        lastLoadID = 0
        getLoads()
    }
    
    @IBAction func onClickEditAddress(_ sender: Any) {
        presentAddressAutoComplete()
    }
    
    @objc
    private func onClickSeeDetails(_ sender: UIButton) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "BidDetailController") as? BidDetailController else {
            return
        }
        
        let loadInfo = loadList[sender.tag]
        vc.loadInfo = loadInfo
        
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - GMSAutocompleteViewControllerDelegate

extension BidsViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        viewController.dismiss(animated: true)
        
        addressText.text = place.formattedAddress
        
        pickupAddr = place.formattedAddress ?? ""
        pickupCoordinate = place.coordinate        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        viewController.dismiss(animated: true)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true)
    }
    
}

// MARK: - UITextFieldDelegate

extension BidsViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == addressText {
            presentAddressAutoComplete()
        }
        return true
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension BidsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadList.count
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
        
        if indexPath.row < loadList.count {
            let loadInfo = loadList[indexPath.row]
            
            cell.showLoadInfo(loadInfo)
        }
        
        if indexPath.row == loadList.count - 1 {
            print("//////// lastItemReached...")
            lastLoadID = loadList.last?.id ?? 0
            getLoads()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex
            && indexPath.row == lastRowIndex {
            
            // print("this is the last cell")
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
