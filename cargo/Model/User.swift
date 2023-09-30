//
//  User.swift
//  cargo
//
//  Created by Apple on 9/26/23.
//

import Foundation
import CoreLocation

enum ProfileStatus: Int {
    case pending = 0
    case approved = 1
    case blocked = 2
    case deleted = 3
}

enum UserAvailability: Int, Codable {
    case notAvailable = 0
    case available = 1
}

// MARK: - VehicleDimension

struct VehicleDimension: Codable {
    
    var length: Double = 0
    var width: Double = 0
    var height: Double = 0
    
    init() {
        
    }
    
    init(_ dic: [String: Any]) {
        if let value = dic["length"] as? Double {
            length = value
        }
        if let value = dic["width"] as? Double {
            width = value
        }
        if let value = dic["height"] as? Double {
            height = value
        }
    }
    
    func jsonObj() -> [String: Any] {
        return [
            "length": length,
            "width": width,
            "height": height
        ]
    }
}

// MARK: - User Model

struct User: Codable {
    
    var id = ""
    var name = ""
    var email = ""
    var password = ""
    var phone = ""
    var status = 0
    var vehicle: VehicleDimension = VehicleDimension()
    var photo = ""
    
    var address = ""
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    var availability: UserAvailability = .notAvailable
    
    init() {
        
    }
    
    init(_ dic: [String: Any]) {
        if let value = dic["id"] as? String {
            id = value
        }
        if let value = dic["name"] as? String {
            name = value
        }
        if let value = dic["email"] as? String {
            email = value
        }
        if let value = dic["phone"] as? String {
            phone = value
        }
        if let value = dic["status"] as? Int {
            status = value
        }
        if let value = dic["vehicle"] as? [String: Any] {
            vehicle = VehicleDimension(value)
        }
        if let value = dic["photo"] as? String {
            photo = value
        }
        if let value = dic["address"] as? String {
            address = value
        }
        if let value = dic["latitude"] as? CLLocationDegrees {
            latitude = value
        }
        if let value = dic["longitude"] as? CLLocationDegrees {
            longitude = value
        }
        if let value = dic["available"] as? Int, let enumValue = UserAvailability(rawValue: value) {
            availability = enumValue
        }
    }
    
    func statusValue() -> ProfileStatus {
        return ProfileStatus(rawValue: status) ?? .pending
    }
    
    func jsonObj() -> [String: Any] {
        return [
            "id"       : id,
            "name"     : name,
            "email"    : email,
            "phone"    : phone,
            "status"   : status,
            "vehicle"  : vehicle.jsonObj(),
            "photo"    : photo,
            "address"  : address,
            "latitude" : latitude,
            "longitude": longitude,
            "available": availability.rawValue
        ]
    }
    
    func save(sync: Bool = false) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            UserDefaults.standard.set(data, forKey: Constants.prefCurrentUser)
            
            if sync {
                FirebaseService.saveUserInfo(user: self, completion: nil)
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    static func user() -> User {
        if let data = UserDefaults.standard.data(forKey: Constants.prefCurrentUser) {
            do {
                let decoder = JSONDecoder()
                let value = try decoder.decode(User.self, from: data)
                return value
            }
            catch {
                print("Tariffs: \(error.localizedDescription)")
            }
        }
        return User()
    }
    
    static func clear() {
        UserDefaults.standard.removeObject(forKey: Constants.prefCurrentUser)
    }
    
}
