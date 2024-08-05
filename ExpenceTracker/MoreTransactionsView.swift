import SwiftUI

class MoreTransactionsViewModel : ObservableObject {
    @Published var MoreTransactions : [Transactions] = []
    
    func fetchAllTransactions() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("No uid found")
            return
        }
        FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
            .collection("transactions")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, err in
                if let err = err {
                    print("Failed to fetch transactions", err)
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No transactions found")
                    return
                }
                self.MoreTransactions = documents.compactMap { document in
                    do {
                        return try document.data(as: Transactions.self)
                    } catch {
                        print("Failed to decode transaction:", error)
                        return nil
                    }
                }
                print("Fetched transactions: \(self.MoreTransactions)") // Debugging print
            }
    }
}

struct MoreTransactionsView: View {
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(red: 29/255, green: 28/255, blue: 32/255, alpha: 1) // Match your background color
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var vm = MoreTransactionsViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: UIColor(red: 29/255, green: 28/255, blue: 32/255, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(vm.MoreTransactions, id: \.id) { transaction in
                            HStack {
                                if let imageName = transaction.imageURL {
                                    Image(imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 70, height: 70)
                                        .clipped()
                                        .cornerRadius(10)
                                } else {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 80, height: 100)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(transaction.category)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    Text(transaction.formattedDate)
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                }
                                
                                Spacer()
                                
                                Text("₹\(transaction.formattedAmount)")
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top , 15)
                        Spacer()
                    }
                    .padding(.top, 10)
                }
                .navigationTitle("All Transactions")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "arrow.backward")
                                .font(.headline)
                            Text("Back")
                                .font(.system(size: 25))
                        })
                    }
                }
            }
            .onAppear {
                vm.fetchAllTransactions()
            }
        }
    }
}

#Preview {
    MoreTransactionsView()
}
