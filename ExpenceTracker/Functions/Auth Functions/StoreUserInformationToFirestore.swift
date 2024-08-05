//
//  StoreUserInformationToFirestore.swift
//  ExpenceTracker
//
//  Created by SHIVANSH PANDE on 20/07/24.
//
import SwiftUI
import Foundation
import Firebase
import FirebaseFirestore

func StoreUserInfoToFirestore(){
    let email = AuthManager.shared.email
    let username = AuthManager.shared.username
    let currentBalance = AuthManager.shared.currentBalance
    guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
    
    let userdata = ["email" : email, "uid": uid , "username" : username , "currentBalance": currentBalance]
    FirebaseManager.shared.firestore.collection("users").document(uid).setData(userdata){err in
        if let err = err {
            print("Cannot upload data to firestore", err)
            return
        }
        
        print("Success in uploading data")
    }
}
