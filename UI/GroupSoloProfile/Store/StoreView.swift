//
//  StoreView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/18/23.
//

import SwiftUI


struct StoreView: View {
    
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(.white)
                  
              }
          }
      }
    let groupId : String
    @State private var canPurchaseLovols : Bool = false
    @State private var tokens : Tokens = Tokens()
    @State private var confirmBuy : Bool = false
    
    @State private var notEnoughLovolBits : Bool = false
    
    @State private var pendingQuantity : Int = 0
    @State private var pendingCost : Int = 0
    
    @State private var storeLoadError : Bool = false
    @State private var purchaseError : Bool = false

    var body: some View {
        
        GeometryReader{geo in
            ScrollView{
                VStack(){
                    StoreHeaderView(groupId:groupId, tokens: $tokens, cantPurchaseLovols: $canPurchaseLovols)
                        .frame(height:geo.size.height * 0.3)
                    VStack(spacing:0){
                        HStack{
                            Text("Lovols")
                                .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.leading)
                        HStack{
                            
                            Button {
                                
                                if tokens.lovolBits < 100 {
                                    self.notEnoughLovolBits = true
                                }else{
                                    self.pendingQuantity = 1
                                    self.pendingCost = 100
                                    self.confirmBuy = true
                                }
                       
                            } label: {
                                PurchaseLovolToken(quantity: 1, cost: 100)
                            }
                            Button {
                                if tokens.lovolBits < 200 {
                                    self.notEnoughLovolBits = true

                                }else{
                                    self.pendingQuantity = 2
                                    self.pendingCost = 200
                                    self.confirmBuy = true
                                }

                            } label: {
                                PurchaseLovolToken(quantity: 2, cost: 200)
                            }
                            Button {
                                if tokens.lovolBits < 300 {
                                    self.notEnoughLovolBits = true

                                }else{
                                    self.pendingQuantity = 3
                                    self.pendingCost = 300
                                    self.confirmBuy = true
                                }

                            } label: {
                                PurchaseLovolToken(quantity: 3, cost: 300)
                            }
                        }
                        .padding()
                    }
                    .frame(height:geo.size.height * 0.25)

                    VStack(spacing:0){
                        HStack{
                            Text("Doubler Tokens")
                                .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
                            Spacer()
                        }            .padding(.leading)
                        
                        
                        HStack{
                            PurchaseMultiplierToken(quantity: 2, cost: 0.99)
                            PurchaseMultiplierToken(quantity: 10, cost: 4.99)
                            PurchaseMultiplierToken(quantity: 20, cost: 9.99)
                            
                        }
                        .padding()
                    }
                    .frame(height:geo.size.height * 0.25)

                    VStack(spacing:0){
                        HStack{
                            Text("Resurrection Tokens")
                                .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
                            Spacer()
                        }            .padding(.leading)
                        
                        HStack{
                            PurchaseResurrectionToken(quantity:1,cost:49.99)
                            PurchaseResurrectionToken(quantity:2,cost:99.99)
                            PurchaseResurrectionToken(quantity:4,cost:199.99)
                            
                        }
                        .padding()
                    }
                    .frame(height:geo.size.height * 0.25)

                }
            }
        }
        .padding()
        .background(BackgroundView())

        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Confirm that you want to exchange \(pendingCost) lovol bits for \(pendingQuantity) Lovols.", isPresented: $confirmBuy, actions: {
            Button("Yes", role: .none, action: {
                purchaseLovols(quantity: pendingQuantity, cost: pendingCost)
            })
            Button("No",role:.cancel, action:{
//                self.delete = false
                self.pendingCost = 0
                self.pendingQuantity = 0
                self.confirmBuy = false
            })
        })
        .alert("You don't have enough lovol bits to complete this transaction. Do more events with your team!", isPresented: $notEnoughLovolBits, actions: {
            Button("OK", role: .cancel, action: {
                self.notEnoughLovolBits = false

            })
        })
        .alert("Looks like you don't have enough lovol bits to complete this transaction.", isPresented: $purchaseError, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
        .alert("There was an error connecting to the database. Please try again.", isPresented: $storeLoadError, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
    }
    
    private func purchaseLovols(quantity:Int,cost:Int){
        
        profileViewModel.exchangeTokens(quantity: quantity, cost: cost, groupId: groupId) { result in
            switch result{
            case .success(true):
                self.tokens.lovolBits -= cost
                self.tokens.lovols += quantity

            case .success(false):
                print("error buying")
                self.purchaseError = true
            case .failure(let error):
                print("error buying \(error)")
                self.storeLoadError = true
            }
        }
        
        
    }
    

}

//struct StoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreView()
//    }
//}
