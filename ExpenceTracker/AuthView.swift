//
//  AuthView.swift
//  ExpenceTracker
//
//  Created by SHIVANSH PANDE on 19/07/24.
//

import SwiftUI
import Firebase

struct AuthView: View {
    
    let didCompleteLoginProcess: () -> ()
        
        init(didCompleteLoginProcess: @escaping () -> ()) {
            self.didCompleteLoginProcess = didCompleteLoginProcess
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = UIColor(red: 29/255, green: 28/255, blue: 32/255, alpha: 1)
            
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
            UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(red: 213/255, green: 185/255, blue: 254/255, alpha: 1)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
            UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
            UISegmentedControl.appearance().backgroundColor = UIColor.gray
        }
    


    @ObservedObject var authManager = AuthManager.shared
    var body: some View {
        NavigationView{
            ZStack{
                Color(uiColor: UIColor(red: 29/255, green: 28/255, blue: 32/255, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
                ScrollView{
                    VStack(spacing : 16){
                        Picker(selection: $authManager.isloginMode ,label: Text("Picker here")){
                            Text("Login")
                                .tag(true)
                            Text("Create Account")
                                .tag(false)
                        }.pickerStyle(SegmentedPickerStyle())
                            .padding()
                        
                        if !authManager.isloginMode {
                            VStack{
                                TextField("Username", text: $authManager.username)
                                    .padding(12)
                                    .background()
                                    .cornerRadius(10)
                                TextField("Email", text: $authManager.email)
                                    .padding(12)
                                    .background(Color.white)
                                    .keyboardType(.emailAddress)
                                    .cornerRadius(10)
                                    .padding(.top)
                                TextField("Password" , text: $authManager.password)
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding(.top)
                                TextField("Enter the amount you want to start", text: $authManager.currentBalance)
                                    .padding(12)
                                    .background()
                                    .keyboardType(.numberPad)
                                    .cornerRadius(10)
                                    .padding(.top)
                            }
                        }else{
                            VStack{
                                TextField("Email", text: $authManager.email)
                                    .padding(12)
                                    .background(Color.white)
                                    .keyboardType(.emailAddress)
                                    .cornerRadius(10)
                                    .padding(.top)
                                TextField("Password" , text: $authManager.password)
                                    .padding(12)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding(.top)
                            }
                        }
                        Button(action: {
                            handleAction(didCompleteLoginProcess: didCompleteLoginProcess)
                        }, label: {
                            Capsule()
                                .fill(Color(uiColor: UIColor(red: 213/255, green: 185/255, blue: 254/255, alpha: 1)))
                                .frame(width: 250 , height: 45)
                                .overlay(
                                    Text(authManager.isloginMode ? "Log In" : "Create Account")
                                        .foregroundStyle(Color.black)
                                )
                        })
                    }.padding()
                }
            }
            .navigationTitle(authManager.isloginMode ? "Log In" : "Create Account")
        }
    }
}

#Preview {
    AuthView(didCompleteLoginProcess: {
        
    })
}
