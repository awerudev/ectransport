//
//  HomeViewController.swift
//  cargo
//
//  Created by Apple on 9/19/23.
//

import UIKit
import MapKit
import SDWebImage
import MBProgressHUD

class HomeViewController: UIViewController {
    
    @IBOutlet weak var topView: GradientView!    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    private var lastLoad: LoadData? = nil
    
    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: Constants.notifyProfileUpdated), object: nil, queue: OperationQueue.main) { notification in
            self.showUserInfo()
        }
        
        initLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        getLastLoad()
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
        // MapView
        mapView.layer.cornerRadius = Constants.cornerRadius1
        mapView.delegate = self
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        
        userImage.setBorder(UIColor(named: "White")!)
        
        showUserInfo()
    }
    
    private func showUserInfo() {
        let user = User.user()
        nameLabel.text = user.name
        if !user.photo.isEmpty {
            userImage.sd_setImage(with: URL(string: user.photo), placeholderImage: UIImage.defaultUserPhoto(), options: .continueInBackground) { image, error, cacheType, url in
                
            }
        }
        tableView.reloadData()
    }
    
    private func presentArriveConfirm() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ArriveConfirmController") as? ArriveConfirmController else {
            return
        }
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    private func presentLoadInfo() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "LoadInfoController") as? LoadInfoController else {
            return
        }
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
    }
    
    private func reloadMapView() {
        guard let lastLoad = lastLoad else {
            return
        }
        
        let pickupAt = MKPointAnnotation()
        let pickupCoordinate = CLLocationCoordinate2D(latitude: lastLoad.pickupAt.latitude, longitude: lastLoad.pickupAt.longitude)
        let pickupPoint = MKMapPoint(pickupCoordinate)
        pickupAt.title = lastLoad.pickupAt.formattedAddress
        pickupAt.coordinate = pickupCoordinate
        mapView.addAnnotation(pickupAt)
        
        let deliverTo = MKPointAnnotation()
        let deliverToCoordinate = CLLocationCoordinate2D(latitude: lastLoad.deliverTo.latitude, longitude: lastLoad.deliverTo.longitude)
        let deliverToPoint = MKMapPoint(deliverToCoordinate)
        deliverTo.title = lastLoad.deliverTo.formattedAddress
        deliverTo.coordinate = deliverToCoordinate
        mapView.addAnnotation(deliverTo)
        
        var minPoint = pickupPoint
        var maxPoint = minPoint
        if deliverToPoint.x < minPoint.x {
            minPoint.x = deliverToPoint.x
        }
        if deliverToPoint.y < minPoint.y {
            minPoint.y = deliverToPoint.y
        }
        if deliverToPoint.x > maxPoint.x {
            maxPoint.x = deliverToPoint.x
        }
        if deliverToPoint.y > maxPoint.y {
            maxPoint.y = deliverToPoint.y
        }
        
        mapView.setVisibleMapRect(
            MKMapRect(
                origin: minPoint,
                size: MKMapSize(width: maxPoint.x - minPoint.x, height: maxPoint.y - minPoint.y)
            ),
            edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
            animated: true
        )
        
        // Routes
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lastLoad.pickupAt.latitude, longitude: lastLoad.pickupAt.longitude), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: lastLoad.deliverTo.latitude, longitude: lastLoad.deliverTo.longitude), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            //for getting just one route
            if let route = unwrappedResponse.routes.first {
                //show on map
                self.mapView.addOverlay(route.polyline)
                //set the map area to show the route
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
            }

            //if you want to show multiple routes then you can get all routes in a loop in the following statement
            //for route in unwrappedResponse.routes {}
        }
    }
    
    private func getLastLoad() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        FirebaseService.getLastLoad { data, error in
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = data {
                self.lastLoad = data
                self.reloadMapView()
            }
            else {
                self.lastLoad = nil
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Action
    
    @objc
    private func onClickAction(_ sender: UIButton) {
        presentArriveConfirm()
    }        
    
    @objc
    private func onFindLoadsNow(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notifyPresentBids), object: nil)
    }
    
    @objc
    private func onClickViewLoad(_ sender: UIButton) {
        guard let lastLoad = lastLoad else {
            return
        }
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "BidDetailController") as? BidDetailController else {
            return
        }
        vc.loadInfo = lastLoad
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func onClickAcceptLoad(_ sender: UIButton) {
        guard let lastLoad = lastLoad else {
            return
        }
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "BidDetailController") as? BidDetailController else {
            return
        }
        vc.loadInfo = lastLoad
        vc.accept = true
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - MKMapViewDelegate

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(named: "TextRed")
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 { // My Address
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeAddressTableCell", for: indexPath) as! HomeAddressTableCell
            cell.parentViewController = self
            
            let user = User.user()
            cell.addressText.text = user.address
            cell.addrCoordiate = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude)
            cell.onAvailabilityChange = {
                self.tableView.reloadData()
            }
            
            if user.availability == .notAvailable {
                cell.scheduleButton.backgroundColor = UIColor(named: "TextGray")
                cell.scheduleButton.setTitle("Available", for: .normal)
                cell.scheduleButton.setTitleColor(UIColor(named: "White"), for: .normal)
                
                cell.availableLabel.text = "I'm Not Available"
                cell.availableLabel.textColor = UIColor(named: "TextRed")
            }
            else {
                cell.scheduleButton.backgroundColor = UIColor.clear
                cell.scheduleButton.setTitle("Not Available", for: .normal)
                cell.scheduleButton.setTitleColor(UIColor(named: "TextGray"), for: .normal)
                
                cell.availableLabel.text = "I'm Available"
                cell.availableLabel.textColor = UIColor(named: "TextGreen")
            }
            
            return cell
        }
        else if indexPath.row == 1 {
            if let lastLoad = lastLoad {
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeLoadTableCell", for: indexPath) as! HomeLoadTableCell
    
                cell.showLoadInfo(lastLoad)
                
                cell.viewButton.addTarget(self, action: #selector(onClickViewLoad(_:)), for: .touchUpInside)
                cell.acceptButton.addTarget(self, action: #selector(onClickAcceptLoad(_:)), for: .touchUpInside)
                
                return cell
            }
            else { // Find Loads Cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNoLoadTableCell", for: indexPath) as! HomeNoLoadTableCell
                
                cell.findLoadButton.addTarget(self, action: #selector(onFindLoadsNow(_:)), for: .touchUpInside)
                
                return cell
            }
        }
//        else if indexPath.row == 2 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeLoadTableCell", for: indexPath) as! HomeLoadTableCell
//            
//            return cell
//        }
//        else if indexPath.row == 3 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTransitTableCell", for: indexPath) as! HomeTransitTableCell
//            
//            cell.actionButton.addTarget(self, action: #selector(onClickAction(_:)), for: .touchUpInside)
//            
//            return cell
//        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


