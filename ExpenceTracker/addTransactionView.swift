//
//  addTransactionView.swift
//  ExpenceTracker
//
//  Created by SHIVANSH PANDE on 16/07/24.
//

import SwiftUI
import FirebaseFirestore


struct addTransactionView: View {
    @ObservedObject var authManager = AuthManager.shared
    @State var selectedCategory : Category? = nil
    @State var amount = ""
    @State var remark = ""
    @State var transactionID : String = UUID().uuidString
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    init() {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = UIColor(red: 29/255, green: 28/255, blue: 32/255, alpha: 1) // Match your background color

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
    var body: some View {
        NavigationView{
            ZStack{
                Color(uiColor: UIColor(red: 29/255, green: 28/255, blue: 32/255, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    HStack{
                        Text("Category:")
                            .font(.system(size: 20).bold())
                            .foregroundStyle(Color.white)
                            .padding(.top , 50)
                            .padding()
                        Picker("Select Category", selection: $selectedCategory){
                            ForEach (categories, id: \.name){category in
                                Text(category.name).tag(category as Category?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding(.top,50)
                        .padding()
                        
                        Spacer()
                    }
                    HStack{
                        Text("Amount:")
                            .font(.system(size: 20).bold())
                            .foregroundStyle(Color.white)
                            .padding()
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(width: 190,height: 45)
                            .overlay(
                                    TextField("Amount", text: $amount)
                                        .padding()
                            )
                        Spacer()
                    }
                    HStack{
                        Text("Remark:")
                            .font(.system(size: 20).bold())
                            .foregroundStyle(Color.white)
                            .padding()
                        
                            TextEditor(text: $remark)
                            .frame(width: 230, height: 50)
                            .cornerRadius(18)
                            
                        
                        Spacer()
                    }
                    Spacer()
                }
                Button(action: {
                    addTransaction()
                }, label: {
                    Capsule()
                        .fill(Color(uiColor: UIColor(red: 213/255, green: 185/255, blue: 254/255, alpha: 1)))
                        .frame(width: 170 , height: 50)
                        .overlay(Text("Add")
                            .font(.system(size: 18).bold())
                            .foregroundStyle(Color.black)
                        )
                })
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Transactions"), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                        presentationMode.wrappedValue.dismiss()
                    }))
                }
                
            }
            .ignoresSafeArea(.keyboard)
            .navigationTitle("Add Transactions")
        }
    }
    private func addTransaction() {
          
           guard let selectedCategory = selectedCategory else {
               alertMessage = "Please select a category."
               showAlert = true
               return
           }
           
           
           guard let amountValue = Double(amount) else {
               alertMessage = "Please enter a valid amount."
               showAlert = true
               return
           }

           
           guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
               alertMessage = "User not logged in."
               showAlert = true
               return
           }

           
           let transactionData: [String: Any] = [
               "category": selectedCategory.name,
               "imageURL": selectedCategory.imageName,
               "amount": amountValue,
               "remark": remark,
               "transactionID": transactionID,
               "timestamp" : Timestamp(date : Date())
           ]

          
           FirebaseManager.shared.firestore
               .collection("users")
               .document(uid)
               .getDocument { document, error in
                   if let error = error {
                       alertMessage = "Error retrieving balance: \(error.localizedDescription)"
                       showAlert = true
                       return
                   }

                   guard let document = document, document.exists,
                         let data = document.data(),
                         let currentBalanceString = data["currentBalance"] as? String,
                         let currentBalanceValue = Double(currentBalanceString) else {
                       alertMessage = "Current balance is not valid."
                       showAlert = true
                       return
                   }
                   
                   let newBalanceValue : Double
                   if selectedCategory.name == "Add Money"{
                       newBalanceValue = currentBalanceValue + amountValue
                   }else{
                       newBalanceValue = currentBalanceValue - amountValue
                   }
                   
                   let newBalanceString = String(format: "%.2f" , newBalanceValue)
                   
                   
                   FirebaseManager.shared.firestore
                       .collection("users")
                       .document(uid)
                       .collection("transactions")
                       .document(transactionID)
                       .setData(transactionData) { err in
                           if let err = err {
                               alertMessage = "Error saving transaction: \(err.localizedDescription)"
                               showAlert = true
                               return
                           } else {
                               print("Transaction saved successfully!")
                           }
                       }
                   
                  
                   FirebaseManager.shared.firestore
                       .collection("users")
                       .document(uid)
                       .updateData(["currentBalance": newBalanceString]) { err in
                           if let err = err {
                               alertMessage = "Error updating balance: \(err.localizedDescription)"
                               showAlert = true
                               return
                           } else {
                               print("Balance updated successfully!")
                               alertMessage = "Transaction added successfully."
                               showAlert = true
                           }
                       }
               }
       }
   }

   #Preview {
       addTransactionView()
   }
