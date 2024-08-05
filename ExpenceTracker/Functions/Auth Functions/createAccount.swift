//
//  createAccount.swift
//  ExpenceTracker
//
//  Created by SHIVANSH PANDE on 20/07/24.
//

import Foundation
import Firebase
import FirebaseFirestore

func createAccount(didCompleteLoginProcess: @escaping () -> ()) {
    let email = AuthManager.shared.email
    let password = AuthManager.shared.password
    FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, err in
        if let err = err {
            print("Cannot create user", err)
            return
        }
        print("Created user with uid: \(result?.user.uid ?? "")")
        
        StoreUserInfoToFirestore()

        didCompleteLoginProcess()
    }
}
