//
//  FirebaseService.swift
//  cargo
//
//  Created by Apple on 9/26/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FirebaseService: NSObject {
    
    static let users = Firestore.firestore().collection("users")
    
    static var isLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    static var currentUserId: String? {
        return Auth.auth().currentUser?.uid
    }
    
    open class func loginWith(email: String, password: String, completion: ((Error?) -> Void)?) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion?(error)
                return
            }
            if let result = authResult {
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
                
                completion?(user)
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
        }
        catch {
            print("======== logout Error: \(error.localizedDescription)")
        }
    }

}
