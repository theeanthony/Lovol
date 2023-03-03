//
//  StoreView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/18/23.
//

import SwiftUI


struct StoreView: View {
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
    var body: some View {
        
        GeometryReader{geo in
            ScrollView{
                VStack(){
                    StoreHeaderView(groupId:groupId, cantPurchaseLovols: $canPurchaseLovols)
                        .frame(height:geo.size.height * 0.3)
                    VStack(spacing:0){
                        HStack{
                            Text("Lovols")
                                .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.leading)
                        HStack{
                            PurchaseLovolToken(quantity: 1, cost: 100)
                            PurchaseLovolToken(quantity: 2, cost: 200)
                            
                            PurchaseLovolToken(quantity: 3, cost: 300)
                            
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
    }
    

}

//struct StoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreView()
//    }
//}
