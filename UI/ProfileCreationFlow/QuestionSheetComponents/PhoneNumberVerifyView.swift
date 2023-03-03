//
//  PhoneNumberVerifyView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/12/23.
//

import SwiftUI

struct PhoneNumberVerifyView: View {
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
    var body: some View {
        GeometryReader{
            geo in
            
            VStack{
                
                Spacer()
                
                HStack{
                    Spacer()
                    Text("Enter Phone Number")
                        .font(.custom("Rubik Bold", size: 22)).foregroundColor(.white)
                    Spacer()
                }
                  
                
                Button {
                    
                } label: {
                    NavigationLink(destination: PhoneNumberVerifyView()) {
                        Text("Next")
                            .padding()
                            .frame(width:geo.size.width * 0.9)
//                            .background(RoundedRectangle(cornerRadius: 30).fill( text.count == 10 ? AppColor.lovolDarkPurple : AppColor.lovolDarkPurple.opacity(0.5)))
                    }
             
                }
//                .disabled(text.count != 10 )

        
                
                Spacer()
                
            }
            .frame(width:geo.size.width , height:geo.size.height)
            .ignoresSafeArea(.keyboard)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            
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
        }
   
       
    }
}

struct PhoneNumberVerifyView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberVerifyView()
    }
}
