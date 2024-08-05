//
//  ActiveUser.swift
//  ExpenceTracker
//
//  Created by SHIVANSH PANDE on 20/07/24.
//

import Foundation
import FirebaseFirestoreSwift

struct ActiveUser: Codable, Identifiable {
    @DocumentID var id: String?
    let uid: String
    let username: String
    let email: String
    let currentBalance: String
}
