//
//  QuickSheet.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 3/17/23.
//

import SwiftUI

struct QuickSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var text : String
    var body: some View {
        HStack{
            Spacer()
            VStack{
                Spacer()
                Text(text)                            .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
                
                Spacer()
                Button {
                    
                } label: {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Alright")
                            .font(.custom("Rubik Bold", size: 16)).foregroundColor(.white)
                        
                            .padding()
                            .padding(.horizontal,25)
                            .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                    }
                    
                }
                Spacer()
                
            }
            .padding(.horizontal)
            Spacer()
        }
        .background(AppColor.lovolDark)

    }
}

//struct QuickSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        QuickSheet()
//    }
//}
