//
//  AlliancePlusSheet.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/20/23.
//

import SwiftUI

struct AlliancePlusSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        HStack{
            Spacer()
            VStack{
                Spacer()
                Text("This event will only show up for your alliances and the alliances of your alliances.")
                    .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
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
        .background(AppColor.lovolDark)
    }
}

struct AlliancePlusSheet_Previews: PreviewProvider {
    static var previews: some View {
        AlliancePlusSheet()
    }
}
