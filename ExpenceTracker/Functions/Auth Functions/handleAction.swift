//
//  handleAction.swift
//  ExpenceTracker
//
//  Created by SHIVANSH PANDE on 20/07/24.
//

import Foundation

func handleAction(didCompleteLoginProcess: @escaping () -> ()){
    let isloginMode = AuthManager.shared.isloginMode
    
    if isloginMode {
        loginUser(didCompleteLoginProcess: didCompleteLoginProcess)
    }else{
        createAccount(didCompleteLoginProcess: didCompleteLoginProcess)
    }
}


