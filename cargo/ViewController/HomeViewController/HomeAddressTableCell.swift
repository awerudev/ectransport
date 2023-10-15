//
//  HomeAddressTableCell.swift
//  cargo
//
//  Created by Apple on 9/25/23.
//

import UIKit
import GooglePlaces

class HomeAddressTableCell: UITableViewCell {
    
    var parentViewController: UIViewController? = nil
    var addrCoordiate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var onAvailabilityChange: (() -> Void)? = nil
    var onLocationChange: (() -> Void)? = nil
    
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressInputView: UIView!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var scheduleButton: UIButton!
    @IBOutlet weak var editAddressButton: UIButton!
    @IBOutlet weak var availableLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Address View
        addressView.setBorder(UIColor(named: "ViewBorder")!, width: 1, cornerRadius: Constants.cornerRadius1)
        addressInputView.setBorder()
        
        // Schedule Button
        scheduleButton.setBorder(UIColor(named: "TextGray")!, width: 1, cornerRadius: scheduleButton.frame.size.height / 2)
//        scheduleButton.clipsToBounds = true
        
        addressText.delegate = self
        
        scheduleButton.addTarget(self, action: #selector(onAvailabilityChange(_:)), for: .touchUpInside)
        editAddressButton.addTarget(self, action: #selector(onClickEditAddress(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - My Method
    
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
        parentViewController?.present(autocompleteController, animated: true, completion: nil)
    }
    
    // MARK: - Action
    
    @objc
    private func onClickEditAddress(_ sender: UIButton) {
        presentAddressAutoComplete()
    }
    
    @objc
    private func onAvailabilityChange(_ sender: UIButton) {
        var user = User.user()
        if user.availability == .available {
            user.availability = .notAvailable
        }
        else if user.availability == .notAvailable {
            user.availability = .available
        }
        user.save(sync: true)
        
        onAvailabilityChange?()
    }

}

// MARK: - GMSAutocompleteViewControllerDelegate

extension HomeAddressTableCell: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        viewController.dismiss(animated: true)
        
        addressText.text = place.formattedAddress
        addrCoordiate = place.coordinate
        
        var user = User.user()
        user.address = place.formattedAddress ?? ""
        user.latitude = addrCoordiate.latitude
        user.longitude = addrCoordiate.longitude
        user.save(sync: true)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        viewController.dismiss(animated: true)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        viewController.dismiss(animated: true)
    }
    
}

// MARK: - UITextFieldDelegate

extension HomeAddressTableCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        presentAddressAutoComplete()
        return true
    }
    
}
