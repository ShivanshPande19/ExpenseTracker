import Foundation
import FirebaseFirestoreSwift

struct Transactions: Identifiable, Codable {
    @DocumentID var id: String?
    var amount: Double
    var category: String
    var imageURL: String?
    var timestamp: Date
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    var formattedAmount: String {
            let amountDouble = Double(amount) ?? 0.0
            return String(format: "%.2f", amountDouble)
        }
}
