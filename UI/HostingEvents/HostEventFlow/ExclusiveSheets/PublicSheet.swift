//
//  PublicSheet.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/20/23.
//

import SwiftUI

struct PublicSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        HStack{
            Spacer()
            VStack{
                Spacer()
                Text("This event will be open to the public around you.")                            .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
                
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
            Spacer()
        }
        .background(AppColor.lovolDarkerPurpleBackground)

    }
}

struct PublicSheet_Previews: PreviewProvider {
    static var previews: some View {
        PublicSheet()
    }
}
