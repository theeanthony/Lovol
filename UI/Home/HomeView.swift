//
//  HomeView.swift
//  Lovol (iOS)
//
//  Created by Anthony Contreras on 10/18/22.
//

import SwiftUI
import Foundation
import AVKit

struct HomeView: View {
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var profileViewModel : ProfilesViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    var btnBack : some View { Button(action: {
//          self.presentationMode.wrappedValue.dismiss()
//          }) {
//              HStack {
//                  Image(systemName: "chevron.left") // set image here
//                  .aspectRatio(contentMode: .fit)
//                  .foregroundColor(.white)
//
//              }
//          }
//      }
    var videoURL : String
    var isActive : Bool

    @State private var isPresented : Bool = false
    var body: some View {
        NavigationStack{
            
//            Button {
//
//            } label: {VSta
//            VStack{
//
//                if isActive {
//                    Text("Press")
//                        .font(.custom("Rubik Bold", size: 22)).foregroundColor(.white)
//                        .shadow(color: .black,radius: 1,x: 1,y: 1)
//
//                }
                SunTimer()
                
                    .overlay(
                        VStack{
                            HStack{
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image(systemName: "chevron.left") // set image here
                                        .foregroundColor(.white)
                                        .padding()
                    
                                    
                                }
              
                                
                                
                                Spacer()
                            }
                            Spacer()
                        }
                    )
                    .onTapGesture {
                        if isActive{
                            isPresented = true
                        }
                    }
//            }
//            .transaction { transaction in
//                transaction.animation = nil
//            }
//            .fullScreenCover(isPresented: $isPresented) {
//                ExampleVideoView(player: AVPlayer(url: URL(string: videoURL)!), isPresented: $isPresented)
//            }
            .sheet(isPresented: $isPresented) {
                ExampleVideoView(player: AVPlayer(url: URL(string: videoURL)!))
                
                    .presentationDetents([.large])

            }

          
            
        }
        .navigationBarTitle("")
        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: btnBack)

        .navigationBarTitleDisplayMode(.inline)
  
    }
   
    
       


}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView(liveEvent:liveEvent)
//    }
//}
