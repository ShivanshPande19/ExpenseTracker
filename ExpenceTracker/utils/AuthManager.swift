//
//  AuthManager.swift
//  ExpenceTracker
//
//  Created by SHIVANSH PANDE on 20/07/24.
//

import Foundation

class AuthManager : ObservableObject{
    static let shared = AuthManager()
    @Published var isloginMode: Bool = false
    @Published var email  = ""
    @Published var password = ""
    @Published var username = ""
    @Published var currentBalance = ""
    private init(){}
}
