//
//  loginUser.swift
//  ExpenceTracker
//
//  Created by SHIVANSH PANDE on 20/07/24.
//
import Foundation
import Firebase
func loginUser(didCompleteLoginProcess: @escaping () -> ()) {
    let email = AuthManager.shared.email
    let password = AuthManager.shared.password
    FirebaseManager.shared.auth.signIn(withEmail: email, password: password){result, err in
        if let err = err {
            print("Failed to login user" , err)
            return
        }
        print("Successfully login user: \(result?.user.uid ?? "")")
        didCompleteLoginProcess()
    }
}
