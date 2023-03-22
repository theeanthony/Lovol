//
//  OtherTeamProfileView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 3/16/23.
//

import Foundation
import SwiftUI

struct OtherTeamProfileView:View{
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
     @Binding var groupId: String
    @State private var totalEvents : Int = 0
    
    
    var body: some View {
        GeometryReader{geo in
            ScrollView{
                
                VStack{
                    OtherTeamProfileHeaderView(totalEvents:$totalEvents,groupId:groupId)
                        .padding(.top,60)
                    OtherTeamPhotosList(totalEvents:$totalEvents, groupId: groupId)
                        .frame(height:geo.size.height)
                    
                }
                
            }
            .overlay(
                VStack{
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {

                        Image(systemName:"xmark").foregroundColor(.white)
                            .background(Circle().fill(AppColor.lovolDark.opacity(0.6)))
                    }

                    Spacer()
                }
                Spacer()
            }.padding()
            )
        }
        .background(BackgroundView())

            
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform:onAppear)
    }
    private func onAppear(){
        print("group id \(groupId)")
    }

    
    
}
