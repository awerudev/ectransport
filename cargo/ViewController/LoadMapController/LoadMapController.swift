//
//  LoadMapController.swift
//  cargo
//
//  Created by Apple on 10/24/23.
//

import UIKit
import MapKit

class LoadMapController: UIViewController {
    
    var loadList = [LoadData]()

    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initLayout()
        
        reloadMapView()
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
        // Navigation Bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(onClose))
        
        // MapView
        mapView.delegate = self
    }
    
    private func reloadMapView() {
        // Remove Old Annotations
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        
        let user = User.user()
        let userCoordinate = CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude)
        let userPoint = MKMapPoint(userCoordinate)
        let userAnnotation = MKPointAnnotation()
        userAnnotation.title = user.address
        userAnnotation.coordinate = userCoordinate
        mapView.addAnnotation(userAnnotation)
        mapView.selectAnnotation(userAnnotation, animated: true)
        
        let regionRadius = Double(user.distance) * Constants.meterPerMile
        let circle = MKCircle(center: userCoordinate, radius: regionRadius)
        mapView.addOverlay(circle)
        
        var minPoint = userPoint
        var maxPoint = minPoint
        for load in loadList {
            let pickupCoordinate = CLLocationCoordinate2D(latitude: load.pickupAt.latitude, longitude: load.pickupAt.longitude)
            let pickupPoint = MKMapPoint(pickupCoordinate)
            let pickupAt = MKPointAnnotation()
            pickupAt.title = load.pickupAt.formattedAddress
            pickupAt.coordinate = pickupCoordinate
            mapView.addAnnotation(pickupAt)
            
            if pickupPoint.x < minPoint.x {
                minPoint.x = pickupPoint.x
            }
            if pickupPoint.y < minPoint.y {
                minPoint.y = pickupPoint.y
            }
            if pickupPoint.x > maxPoint.x {
                maxPoint.x = pickupPoint.x
            }
            if pickupPoint.y > maxPoint.y {
                maxPoint.y = pickupPoint.y
            }
        }
        
        mapView.setVisibleMapRect(
            MKMapRect(
                origin: minPoint,
                size: MKMapSize(width: maxPoint.x - minPoint.x, height: maxPoint.y - minPoint.y)
            ),
            edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
            animated: true
        )
    }
    
    // MARK: - Action
    
    @objc
    private func onClose() {
        dismiss(animated: true)
    }

}

// MARK: - MKMapViewDelegate

extension LoadMapController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        renderer.strokeColor = UIColor(named: "TextRed")
//        renderer.lineWidth = 5.0
//        
//        return renderer
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.red
        circleRenderer.lineWidth = 3.0
        
        return circleRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "something")
        let user = User.user()
        if user.address == annotation.title {
            annotationView.markerTintColor = .green //custom colors also work, additionally to these default ones
        }
        return annotationView
    }
    
    
}


