//
//  ProfileSection.swift
//  Lovol (iOS)
//
//  Created by Anthony Contreras on 10/18/22.
//


import SwiftUI

struct ProfileSection<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let text: LocalizedStringKey
    var content: () -> Content
    
    init(_ text: String, @ViewBuilder content: @escaping () -> Content) {
        self.text = LocalizedStringKey(text)
        self.content = content
    }
    var body: some View {
        VStack{
            Text(text).font(.footnote).bold().textCase(.uppercase).frame(maxWidth: .infinity, alignment: .leading).foregroundColor(AppColor.lovolTan).padding(.leading)
                .font(.custom("Rubik Bold", size: 14))

//            VStack(spacing: 0, content: content).background(colorScheme == .dark ? Color(UIColor.systemGray6) : .white)
            VStack(spacing: 0, content: content)
        }.padding(.top)

    }
}

struct ProfileSection_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSection("hola"){
            
        }
    }
}
