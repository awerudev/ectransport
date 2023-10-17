//
//  BidInfo.swift
//  cargo
//
//  Created by Apple on 9/30/23.
//

import Foundation

struct BidInfo: Codable {
    
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
    
    var totalPrice: Double = 0
    var vehicle = VehicleDimension()
    var etaAt: TimeInterval = Date().timeIntervalSince1970
    var createdAt: TimeInterval = Date().timeIntervalSince1970
    
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
        
        if let value = dic["totalPrice"] as? Double {
            totalPrice = value
        }
        
        if let value = dic["vehicle"] as? [String: Any] {
            vehicle = VehicleDimension(value)
        }
        
        if let value = dic["etaAt"] as? TimeInterval {
            etaAt = value
        }
        
        if let value = dic["createdAt"] as? TimeInterval {
            createdAt = value
        }
    }
    
    func jsonObj() -> [String: Any] {
        return [
            "id"           : id,
            "pickupAt"     : pickupAt.jsonObj(),
            "pickupDate"   : pickupDate,
            "deliverTo"    : deliverTo.jsonObj(),
            "deliverDate"  : deliverDate,
            "miles"        : miles,
            "pieces"       : pieces,
            "weight"       : weight,
            "dims"         : dims,
            "expireAt"     : expireAt,
            "totalPrice"   : totalPrice,
            "vehicle"      : vehicle.jsonObj(),
            "etaAt"        : etaAt,
            "createdAt"    : createdAt
        ]
    }
    
    func toLoadData() -> LoadData {
        var loadData = LoadData()
        loadData.id = id
        loadData.pickupAt = pickupAt
        loadData.pickupDate = pickupDate
        loadData.deliverTo = deliverTo
        loadData.deliverDate = deliverDate
        loadData.miles = miles
        loadData.pieces = pieces
        loadData.weight = weight
        loadData.dims = dims
        loadData.expireAt = expireAt
        
        return loadData
    }
    
}
