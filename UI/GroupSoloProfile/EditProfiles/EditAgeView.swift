//
//  EditStringView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/1/23.
//

import SwiftUI

struct EditAgeView: View {
 
//    @Binding var isTeam : Bool
    @Binding var over21 : Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(AppColor.lovolTan)
                  
              }
          }
      }
    
        
    var body: some View {
        GeometryReader{ geo in
            
            VStack{
                Spacer()
                HStack{
                    Text("Are you over 21?")
                        .font(.custom("Rubik Regular", size: 12))
                        .foregroundColor(.white)
                        .padding(10)
                    Spacer()
                }
                HStack{
                    Text(over21 ? "Yes" : "No")
                        .font(.custom("Rubik Regular", size: 16))
                        .foregroundColor(.white)
                        .padding(10)


                    Spacer()
               
                }
                .foregroundColor(.white)

                .frame(width:geo.size.width)
                .background(AppColor.lovolDarkPurple.opacity(0.3))
                HStack{
                    Spacer()
                    Button {
                        self.over21 = true

                    } label: {
                        Text("Yes")
                            .padding(15)
                            .font(.custom("Rubik Regular", size: 12))
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 20).fill(over21 ? AppColor.lovolPinkish : AppColor.lovolDarkerPurpleBackground))
                    }
                    Spacer()
                    Button {
                        self.over21 = false
                    } label: {
                        Text("No")
                            .padding(15)
                            .font(.custom("Rubik Regular", size: 12))
                            .foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 20).fill(!over21 ? AppColor.lovolPinkish : AppColor.lovolDarkerPurpleBackground))
                    }
                    Spacer()


                }
                .padding()
     
        
                
//                .padding(.leading,5)
                

         
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Done")
                        .font(.custom("Rubik Bold", size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width:geo.size.width * 0.7)
                        .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolDarkerPurpleBackground))
                }
                Spacer()
            }
     
            
            
            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            .background(BackgroundView())

            
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        

            
            
        }
    }
            
            
        
}

struct EditAgeView_Previews: PreviewProvider {
    @State static var over21 : Bool = true
    static var previews: some View {
        EditAgeView(over21: $over21)
    }
}
