//
//  RoleSheeet.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import SwiftUI

struct RoleSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        GeometryReader{geo in
            VStack{
                VStack{
                    Image(systemName:"lasso.and.sparkles")
                        .resizable()
                        .frame(width:60,height:60)
                        .foregroundColor(.white)
//                    Text("Your pseudo role is what you have always wanted to be.")
//                        .font(.custom("Rubik Bold", size: 18)).foregroundColor(.white)
//                        .multilineTextAlignment(.center)
//                        .padding()

                    Text("Remember when you were a kid and were asked what you wanted to be when you grow up?")
                        .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(width:geo.size.width * 0.7)

//                    Text("I be potato")
//                        .font(.custom("Rubik Regular", size: 18)).foregroundColor(.white)
//                        .padding()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Alright").padding().frame(width:geo.size.width * 0.65).background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                            .font(.custom("Rubik Regular", size: 18)).foregroundColor(.white)
                    }
                    .padding(.vertical)

                    
                }
                .frame(width:geo.size.width * 0.8)
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .frame(width:geo.size.width, height:geo.size.height)
            .background(AppColor.lovolDark)

            
            
        }
    }
}

struct RoleSheeet_Previews: PreviewProvider {
    static var previews: some View {
        RoleSheet()
    }
}
