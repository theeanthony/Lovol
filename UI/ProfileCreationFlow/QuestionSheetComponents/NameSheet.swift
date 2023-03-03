//
//  NameSheet.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import SwiftUI

struct NameSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        GeometryReader{geo in
            VStack{
                VStack{
                    Image(systemName:"person.crop.square.filled.and.at.rectangle")
                        .resizable()
                        .frame(width:60,height:60)
                        .foregroundColor(.white)
//                    Text("Your pseudo name is your name, or your nick name.")
//                        .font(.custom("Rubik Bold", size: 20)).foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .padding()

                    Text("Choose what you want to be called")
                        .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(width:geo.size.width * 0.8)
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Alright").padding().frame(width:geo.size.width * 0.65).background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                            .font(.custom("Rubik Regular", size: 18)).foregroundColor(.white)
                    }


               

                    
                }
                .frame(width:geo.size.width * 0.9)
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .frame(width:geo.size.width, height:geo.size.height)
            .background(AppColor.lovolDark)

            
            
        }    }
}

struct NameSheet_Previews: PreviewProvider {
    static var previews: some View {
        NameSheet()
    }
}
