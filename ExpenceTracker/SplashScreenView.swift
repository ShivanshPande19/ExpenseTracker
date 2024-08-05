import SwiftUI
import Firebase

class SplashScreenViewModel: ObservableObject {
    @Published var isUserCurrentlyLoggedOut = false
    @Published var shouldNavigate = false
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.checkAuthentication()
        }
    }
    
    func checkAuthentication() {
        self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        withAnimation {
            self.shouldNavigate = true
        }
    }
}

struct SplashScreenView: View {
    @StateObject private var vm = SplashScreenViewModel()
    
    var body: some View {
        Group {
            if vm.shouldNavigate {
                if vm.isUserCurrentlyLoggedOut {
                    AuthView(didCompleteLoginProcess: {
                        self.vm.isUserCurrentlyLoggedOut = false
                        self.vm.shouldNavigate = false
                    })
                    .transition(.opacity)
                } else {
                    ContentView()
                        .transition(.opacity)
                }
            } else {
                ZStack {
                    Color.black.edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("Expense Tracker")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .bold()
                        Text("By Shivansh")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 1.0), value: vm.shouldNavigate)
    }
}

#Preview {
    SplashScreenView()
}
