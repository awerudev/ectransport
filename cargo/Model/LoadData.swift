//
//  LoadData.swift
//  cargo
//
//  Created by Apple on 9/29/23.
//

import Foundation
import CoreLocation

struct LoadAddress: Codable {
    
    var formattedAddress = ""
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    
    init() {
        
    }
    
    init(_ dic: [String: Any]) {
        if let value = dic["formattedAddress"] as? String {
            formattedAddress = value
        }
        if let value = dic["latitude"] as? CLLocationDegrees {
            latitude = value
        }
        if let value = dic["longitude"] as? CLLocationDegrees {
            longitude = value
        }
    }
    
    func jsonObj() -> [String: Any] {
        return [
            "formattedAddress": formattedAddress,
            "latitude"     : latitude,
            "longitude"    : longitude,
        ]
    }
    
}

struct LoadData: Codable {
    
    var id: Int = 0
    var pickupAt = LoadAddress()
    var pickupDate = ""
    var deliverTo = LoadAddress()
    var deliverDate = ""
    var miles = ""
    var pieces = ""
    var weight = ""
    var dims = ""
    var expireAt = ""
    
    init() {
        
    }
    
    init(_ dic: [String: Any]) {
        if let value = dic["id"] as? Int {
            id = value
        }
        
        if let value = dic["pickupAt"] as? String {
            pickupAt.formattedAddress = value
        }
        else if let value = dic["pickupAt"] as? [String: Any] {
            pickupAt = LoadAddress(value)
        }
        
        if let value = dic["pickupDate"] as? String {
            pickupDate = value
        }
        
        if let value = dic["deliverTo"] as? String {
            deliverTo.formattedAddress = value
        }
        else if let value = dic["deliverTo"] as? [String: Any] {
            deliverTo = LoadAddress(value)
        }
        
        if let value = dic["deliverDate"] as? String {
            deliverDate = value
        }
        
        if let value = dic["miles"] as? String {
            miles = value
        }
        
        if let value = dic["pieces"] as? String {
            pieces = value
        }
        
        if let value = dic["weight"] as? String {
            weight = value
        }
        
        if let value = dic["dims"] as? String {
            dims = value
        }
        
        if let value = dic["expireAt"] as? String {
            expireAt = value
        }
    }
    
    func toBidInfo() -> BidInfo {
        var bidInfo = BidInfo()
        bidInfo.id = id
        bidInfo.pickupAt = pickupAt
        bidInfo.pickupDate = pickupDate
        bidInfo.deliverTo = deliverTo
        bidInfo.deliverDate = deliverDate
        bidInfo.miles = miles
        bidInfo.pieces = pieces
        bidInfo.weight = weight
        bidInfo.dims = dims
        bidInfo.expireAt = expireAt
        
        return bidInfo
    }
    
}
