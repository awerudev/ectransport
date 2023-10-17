//
//  FirebaseService.swift
//  cargo
//
//  Created by Apple on 9/26/23.
//

import UIKit
import CoreLocation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class FirebaseService: NSObject {
    
    public static let shared = FirebaseService()
    
    private var userListener: ListenerRegistration? = nil
    
    // MARK: - Firestore
    
    static let users = Firestore.firestore().collection("users")
    static let loads = Firestore.firestore().collection("loads")
    static let bids = Firestore.firestore().collection("bids")
    
    // MARK: - Storage
    
    static let usersStorage = Storage.storage().reference().child("users")
    
    // MARK: - Authentication
    
    static var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    static var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    // MARK: - Service
    
    open class func loginWith(email: String, password: String, completion: ((Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion?(error)
                return
            }
            if let _ = authResult {
                completion?(nil)
            }
        }
    }
    
    open class func signupWith(email: String, password: String, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("signupWith Error: \(error.localizedDescription)")
                completion?(nil, error)
                return
            }
            if let result = authResult {
                completion?(result, nil)
            }
        }
    }
    
    open class func getUserInfo(completion: ((User) -> Void)? = nil) {
        guard let currentUserId = currentUserId else {
            return
        }
        
        users.document(currentUserId).getDocument { docSnapshot, error in
            if let error = error {
                print("======= getUserInfo: \(error.localizedDescription)")
                return
            }
            if let snapshot = docSnapshot, let data = snapshot.data() {
                var user = User(data)
                user.id = currentUserId
                user.save()
                
                if user.uid == 0 {
                    getLastUID { lastUID, error in
                        user.uid = lastUID + 1
                        user.save(sync: true)
                    }
                }
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.notifyProfileUpdated), object: nil)
                
                completion?(user)
            }
        }
    }
    
    open class func listenUserInfo(completion: ((ProfileStatus?, Error?) -> Void)?) {
        guard let currentUserId = currentUserId else {
            return
        }
        
        if let listener = shared.userListener {
            listener.remove()
        }
        
        let userRef = users.document(currentUserId)
        shared.userListener = userRef.addSnapshotListener { docSnapshot, error in
            if let error = error {
                completion?(nil, error)
                return
            }
            if let snapshot = docSnapshot, let data = snapshot.data() {
                let user = User(data)
                completion?(user.statusValue(), nil)
            }
        }
    }
    
    open class func saveUserInfo(user: User, completion: ((Error?) -> Void)?) {
        users.document(user.id).setData(user.jsonObj()) { error in
            completion?(error)
        }
    }
    
    open class func logout() {
        do {
            try Auth.auth().signOut()
            User.clear()
        }
        catch {
            print("======== logout Error: \(error.localizedDescription)")
        }
    }
    
    open class func getLastUID(completion: ((Int, Error?) -> Void)?) {
        users.order(by: "uid", descending: false).limit(to: 1).getDocuments { querySnapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
                completion?(0, error)
                return
            }
            if let snapshot = querySnapshot {
                var lastUID = 0
                for doc in snapshot.documents {
                    let user = User(doc.data())
                    lastUID = user.uid
                }
                
                completion?(lastUID, nil)
            }
        }
    }
    
    open class func uploadUserPhoto(_ data: Data, completion: ((String?, Error?) -> Void)?) {
        guard let currentUserId = currentUserId else {
            return
        }
        
        let photoRef = usersStorage.child(currentUserId).child("\(UUID().uuidString).png")
        photoRef.putData(data) { metaData, error in
            if let error = error {
                print("======= uploadUserPhoto Error: \(error.localizedDescription)")
                completion?(nil, error)
                return
            }
            photoRef.downloadURL { url, error in
                if let error = error {
                    print("======= uploadUserPhoto downloadURL Error: \(error.localizedDescription)")
                    completion?(nil, error)
                    return
                }
                if let url = url {
                    print("======= uploadUserPhoto downloadURL Success: \(url.absoluteString)")
                    completion?(url.absoluteString, nil)
                }
            }
        }
    }
    
    open class func getLastLoad(completion: ((LoadData?, Error?) -> Void)?) {
        loads.order(by: "addedAt", descending: true).limit(to: 1000).getDocuments { querySnapshot, error in
            if let error = error {
                print("=========== getLastLoad Error: \(error.localizedDescription)")
                completion?(nil, error)
                return
            }
            if let snapshot = querySnapshot {
                let user = User.user()
                let userLocation = CLLocation(latitude: user.latitude, longitude: user.longitude)
                var minDistance: Double = 100000000
                var nearestLoad = LoadData()
                
                for doc in snapshot.documents {
                    let loadData = LoadData(doc.data())
                    let loadLocation = CLLocation(latitude: loadData.pickupAt.latitude, longitude: loadData.pickupAt.longitude)
                    let distance = userLocation.distance(from: loadLocation)
                    
                    if distance < minDistance {
                        minDistance = distance
                        nearestLoad = loadData
                    }
                }
                completion?(nearestLoad, nil)
            }
        }
    }
    
    open class func addBid(_ bidInfo: BidInfo, completion: ((Error?) -> Void)?) {
        guard let currentUserId = currentUserId else {
            return
        }
        
        bids.document(currentUserId).collection("bids").document("\(bidInfo.id)").setData(bidInfo.jsonObj()) { error in
            if let error = error {
                print("=========== addBid Error: \(error.localizedDescription)")
                completion?(error)
                return
            }
            completion?(nil)
        }
    }
    
    open class func getBidBy(id: String, completion: ((BidInfo?, Error?) -> Void)?) {
        guard let currentUserId = currentUserId else {
            return
        }
        
        bids.document(currentUserId).collection("bids").document(id).getDocument { docSnapshot, error in
            if let error = error {
                print("============ getBidBy Error: \(error.localizedDescription)")
                completion?(nil, error)
                return
            }
            if let snapshot = docSnapshot, let data = snapshot.data() {
                let bidInfo = BidInfo(data)
                completion?(bidInfo, nil)
                return
            }
            completion?(nil, nil)
        }
    }
    
    open class func cancelBidBy(id: String, completion: ((Error?) -> Void)?) {
        guard let currentUserId = currentUserId else {
            return
        }
        
        bids.document(currentUserId).collection("bids").document(id).delete { error in
            if let error = error {
                print("============ cancelBidBy Error: \(error.localizedDescription)")
                completion?(error)
                return
            }
            completion?(nil)
        }
    }
    
    open class func getLoads(
        lastLoadID: Int,
        minCoordinate: CLLocationCoordinate2D?,
        maxCoordinate: CLLocationCoordinate2D?,
        completion: (([LoadData], Int?, Error?) -> Void)?
    ) {
        var query = loads.order(by: "addedAt", descending: true).limit(to: 100)
        if lastLoadID > 0 {
            query = loads.whereField("id", isLessThan: lastLoadID)
                .order(by: "id", descending: true)
                .limit(to: 100)
        }
        if let _ = minCoordinate, let _ = maxCoordinate {
//            query = loads.whereField("id", isLessThan: lastLoadID)
//                .whereField("pickupAt.latitude", isGreaterThan: min.latitude)
//                .whereField("pickupAt.longitude", isGreaterThan: min.longitude)
//                .whereField("pickupAt.latitude", isLessThan: max.latitude)
//                .whereField("pickupAt.longitude", isLessThan: max.longitude)
//                .order(by: "id", descending: true)
//                .limit(to: 100)
//            query = loads.whereFilter(Filter.andFilter([
//                Filter.whereField("id", isLessThan: lastLoadID),
//                Filter.whereField("pickupAt.latitude", isGreaterThan: min.latitude),
//                Filter.whereField("pickupAt.longitude", isGreaterThan: min.longitude),
//                Filter.whereField("pickupAt.latitude", isLessThan: max.latitude),
//                Filter.whereField("pickupAt.longitude", isLessThan: max.longitude)
//            ]))
//            .order(by: "id", descending: true)
//            .limit(to: 100)
            
            if lastLoadID > 0 {
                query = loads.whereField("id", isLessThan: lastLoadID)
                    .order(by: "id", descending: true)
                    .limit(to: 10000)
            }
            else {
                query = loads.order(by: "id", descending: true).limit(to: 10000)
            }
        }
        
        query.getDocuments { querySnapshot, error in
            if let error = error {
                print("======== getLoads Error: \(error.localizedDescription)")
                completion?([], nil, error)
                return
            }
            if let querySnapshot = querySnapshot {
                var items = [LoadData]()
                for doc in querySnapshot.documents {
                    items.append(LoadData(doc.data()))
                }
                if let min = minCoordinate, let max = maxCoordinate {
                    items = items.filter { item in
                        item.pickupAt.latitude > min.latitude
                        && item.pickupAt.longitude > min.longitude
                        && item.pickupAt.latitude < max.latitude
                        && item.pickupAt.longitude < max.longitude
                    }
                }
                
                var lastLoad: LoadData? = nil
                if let value = querySnapshot.documents.last {
                    lastLoad = LoadData(value.data())
                }
                
                completion?(items, lastLoad?.id, nil)
            }
        }
    }
    
    open class func getLastBids(completion: (([BidInfo], Error?) -> Void)?) {
        guard let currentUserId = currentUserId else {
            return
        }
        
        let lastBidsRef = bids.document(currentUserId).collection("bids").order(by: "createdAt", descending: true).limit(to: 2)
        lastBidsRef.getDocuments { querySnapshot, error in
            if let error = error {
                print("======== getBids Error: \(error.localizedDescription)")
                completion?([], error)
                return
            }
            if let querySnapshot = querySnapshot {
                var items = [BidInfo]()
                for doc in querySnapshot.documents {
                    items.append(BidInfo(doc.data()))
                }
                completion?(items, nil)
            }
        }
    }
    
    open class func getBids(completion: (([BidInfo], Error?) -> Void)?) {
        guard let currentUserId = currentUserId else {
            return
        }
        
        let lastBidsRef = bids.document(currentUserId).collection("bids").order(by: "createdAt", descending: true)
        lastBidsRef.getDocuments { querySnapshot, error in
            if let error = error {
                print("======== getBids Error: \(error.localizedDescription)")
                completion?([], error)
                return
            }
            if let querySnapshot = querySnapshot {
                var items = [BidInfo]()
                for doc in querySnapshot.documents {
                    items.append(BidInfo(doc.data()))
                }
                completion?(items, nil)
            }
        }
    }

}
