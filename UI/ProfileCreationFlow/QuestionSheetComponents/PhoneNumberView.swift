//
//  PhoneNumberView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/12/23.
//

import SwiftUI
import iPhoneNumberField

struct PhoneNumberView: View {
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
    @State var text: String = ""
    @State var isEditing: Bool = false
    let name: String
    let role: String
    let age : Bool
    let pic : UIImage
    @State private var isPresented : Bool = false
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
                    iPhoneNumberField("(000) 000-0000", text: $text, isEditing: $isEditing)
                               .flagHidden(false)
                               .flagSelectable(true)
//                               .defaultRegion("USA")
                               .prefixHidden(false)
                               .clearButtonMode(.never)
                               .font(UIFont(size: 30, weight: .light, design: .monospaced))
                               .maximumDigits(10)
                               .foregroundColor(Color.white)
                               .clearButtonMode(.never)
                               .onClear { _ in isEditing.toggle() }
//                               .accentColor(Color.orange)
                               .padding()
                               .background(Color.clear)
                               .cornerRadius(10)
                               .shadow(color: isEditing ? .gray.opacity(0.6) : .white, radius: 10)
                               .padding()
                               .padding(.horizontal)
                
                Button {
                    
                } label: {

             
                }
                .disabled(text.count < 14 )

        
                
                Spacer()
                
            }
            .frame(width:geo.size.width , height:geo.size.height)
            .ignoresSafeArea(.keyboard)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .ignoresSafeArea(.keyboard)
            .sheet(isPresented: $isPresented) {
                PhoneNumberSheet()
                    .presentationDetents([.medium])
            }
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .navigationBarTrailing) {
                   HStack{
                       Button {
                           isPresented = true 
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

//struct PhoneNumberView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhoneNumberView()
//    }
//}
