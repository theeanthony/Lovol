//
//  PhoneNumberSheet.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/13/23.
//

import SwiftUI

struct PhoneNumberSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        GeometryReader{geo in
            VStack{
                VStack{
                    Image(systemName:"phone.circle")
                        .resizable()
                        .frame(width:60,height:60)
                        .foregroundColor(.white)
         

                    Text("This will make it easier for friends to send you invites")
                        .font(.custom("Rubik Regular", size: 18)).foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(width:geo.size.width * 0.9)

              
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Alright").padding().frame(width:geo.size.width * 0.65).background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                            .font(.custom("Rubik Regular", size: 18)).foregroundColor(.white)
                    }
                    .padding(.vertical)
                    
                }
                .frame(width:geo.size.width * 0.9)
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .frame(width:geo.size.width, height:geo.size.height)
            .background(AppColor.lovolDarkPurple)
            
            
            
        }    }
}

struct PhoneNumberSheet_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberSheet()
    }
}
