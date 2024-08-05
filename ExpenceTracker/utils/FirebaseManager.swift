//
//  FirebaseManager.swift
//  ExpenceTracker
//
//  Created by SHIVANSH PANDE on 20/07/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseManager : NSObject {
    
    static let shared = FirebaseManager()
    
    let auth : Auth
    let firestore : Firestore
    var currentUser : ActiveUser?
    
    override init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        super .init()
        
    }

}
