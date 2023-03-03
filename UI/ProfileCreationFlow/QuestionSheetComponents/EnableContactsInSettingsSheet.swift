//
//  EnableContactsInSettingsSheet.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/13/23.
//

import SwiftUI

struct EnableContactsInSettingsSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        HStack{
            Spacer()
            VStack{
                Spacer()
                Text("Enable Contacts in Settings")
                
                
                Spacer()
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Alright")
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                }
                Spacer()

            }
            Spacer()
        }
        
        .background(AppColor.lovolDarkPurple)
    }
}

struct EnableContactsInSettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        EnableContactsInSettingsSheet()
    }
}
