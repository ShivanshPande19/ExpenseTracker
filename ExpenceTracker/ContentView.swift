import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class ContentViewModel: ObservableObject {
    @Published var activeUser: ActiveUser?
    @Published var isUserCurrentlyLoggedOut = false
    @Published var recentTransactions: [Transactions] = []
    
    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
            self.fetchCurrentUser()
            self.listenForTransactions()
        }
    }
    
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Could not find user id")
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).addSnapshotListener { snapshot, err in
            if let err = err {
                print("Failed to fetch the user data", err)
                return
            }
            
            guard let data = snapshot?.data() else {
                print("Document does not exist")
                return
            }
            
            do {
                let user = try snapshot?.data(as: ActiveUser.self)
                DispatchQueue.main.async {
                    self.activeUser = user
                }
            } catch {
                print("Failed to decode user data", error)
            }
        }
    }
    
    func listenForTransactions() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Could not find user id")
            return
        }
        FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
            .collection("transactions")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, err in
                if let err = err {
                    print("Failed to listen for transactions", err)
                    return
                }
                guard let documents = snapshot?.documents else {
                    print("No transactions found")
                    return
                }
                self.recentTransactions = documents.compactMap { document in
                    do {
                        return try document.data(as: Transactions.self)
                    } catch {
                        print("Failed to decode transaction:", error)
                        return nil
                    }
                }
                print("Updated recentTransactions: \(self.recentTransactions)")
            }
    }
    
    func handleLogOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 4..<12:
            return "Good Morning"
        case 12..<16:
            return "Good Afternoon"
        default:
            return "Good Evening"
        }
    }
}
struct ContentView: View {
    @StateObject private var vm = ContentViewModel()
    @State private var shouldShowLogOutOptions = false
    @State private var shouldNavigateToAddTransactionView = false
    @State private var shouldShowMoreTransactionView = false
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(red: 29/255, green: 28/255, blue: 32/255, alpha: 1)
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    private var customNavBar: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(vm.greeting)
                    .font(.system(size: 38))
                    .foregroundColor(.white)
                
                Text("\(vm.activeUser?.username ?? "")!!")
                    .font(.system(size: 25).bold())
                    .foregroundColor(.white)
            }
            .padding()
            .padding(.top, 3)
            Spacer()
            
            Button(action: {
                shouldShowLogOutOptions.toggle()
            }, label: {
                Image(systemName: "gear")
                    .font(.system(size: 30))
                    .foregroundColor(Color(red: 237/255, green: 202/255, blue: 170/255))
            })
            .padding()
        }
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            ActionSheet(title: Text("Settings"), message: Text("Are you sure you want to log out?"), buttons: [.destructive(Text("Log out"), action: {
                vm.handleLogOut()
            }),
            .cancel()])
        }
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
            AuthView(didCompleteLoginProcess: {
                self.vm.isUserCurrentlyLoggedOut = false
                self.vm.fetchCurrentUser()
                self.vm.listenForTransactions()
            })
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 29/255, green: 28/255, blue: 32/255)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    customNavBar
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 59/255, green: 235/255, blue: 230/255))
                        .frame(width: 360, height: 180)
                        .overlay(
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Current Balance:")
                                        .font(.system(size: 18))
                                        .foregroundColor(Color(red: 79/255, green: 86/255, blue: 86/255))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 20)
//                                    Button(action: {
//                                        // Edit Current Balance Logic
//                                    }, label: {
//                                        Image(systemName: "pencil")
//                                            .font(.system(size: 30))
//                                            .padding()
//                                            .foregroundColor(.black)
//                                    })
                                }
                                
                                Text("₹\(vm.activeUser?.currentBalance ?? "")")
                                    .font(.system(size: 40))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 20)
                                    .padding(.bottom, 20)
                            }
                        )
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Recent Transactions")
                                .font(.system(size: 26))
                                .foregroundColor(.white)
                            Spacer()
                            Button(action: {
                                self.shouldNavigateToAddTransactionView.toggle()
                            }, label: {
                                Image(systemName: "plus.app.fill")
                                    .font(.system(size: 34))
                                    .foregroundColor(Color(red: 237/255, green: 202/255, blue: 170/255))
                            })
                        }
                        .padding()
                        
                        ForEach(vm.recentTransactions.prefix(3), id: \.id) { transaction in
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
                                        .fill(Color.gray)
                                        .frame(width: 70, height: 70)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text(transaction.category)
                                        .font(.system(size: 18))
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    
                                    Text(transaction.formattedDate)
                                        .font(.system(size: 15))
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                }
                                Spacer()
                                
                                Text("₹\(transaction.formattedAmount)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 15))
                                    .padding(.horizontal, 1)
                            }
                            .padding()
                        }
                        Spacer()
                        Button(action: {
                            shouldShowMoreTransactionView.toggle()
                        }, label: {
                            Capsule()
                                .fill(Color(red: 213/255, green: 185/255, blue: 254/255))
                                .frame(width: 250, height: 45)
                                .overlay(
                                    Text("More Transactions")
                                        .foregroundColor(.black)
                                )
                        })
                        .fullScreenCover(isPresented: $shouldShowMoreTransactionView, content: {
                            MoreTransactionsView()
                        })
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $shouldNavigateToAddTransactionView) {
                addTransactionView()
            }
        }
    }
}

#Preview {
    ContentView()
}
