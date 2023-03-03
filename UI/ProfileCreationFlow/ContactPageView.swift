//
//  ContactPageView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/12/23.
//

import SwiftUI

struct ContactPageView: View {
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
//    let email : String

    let name : String
    let role : String
    let pic : UIImage
    let age : Bool
    
    
    
    @State private var invites : [String] = []
    var body: some View {
        
        GeometryReader{geo in
            VStack{
                
//                Text("Contacts in Lovol").font(.custom("Rubik Bold", size: 24)).foregroundColor(.white)
                
                Section(header: ListHeader(text: "Contacts in Lovol")){
                    Button {
                        
                    } label: {
                        Text("Contacts")
                            .padding()
                            .frame(width:geo.size.width * 0.7)
                            .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolDarkerPurpleBackground))
                    }

                }
                .frame(width:geo.size.width * 0.9)
                Section(header: ListHeader(text: "Invites")){
                    
                }
                .frame(width:geo.size.width * 0.9)
//                Text("Contacts in Lovol").font(.custom("Rubik Bold", size: 24)).foregroundColor(.white)


                
            }
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .navigationBarTrailing) {
                   HStack{
                       Button {
//                           nameSheet = true
                       } label: {
                           Image(systemName: "questionmark.circle.fill").foregroundColor(.white)
                       }
                   }


               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .background(AppColor.lovolDark)

            
            
        }
     
        
        
        
    }
}
//
//struct ContactPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactPageView()
//    }
//}
