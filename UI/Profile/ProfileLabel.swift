//
//  ProfileLabel.swift
//  Lovol (iOS)
//
//  Created by Anthony Contreras on 10/18/22.
//

import SwiftUI

struct ProfileLabel: View {
    let title: LocalizedStringKey
    let systemName: String
    let iconColor: Color
    
    init(title: String, systemName: String, iconColor: Color = .accentColor){
        self.title = LocalizedStringKey(title)
        self.systemName = systemName
        self.iconColor = iconColor
    }
    
    var body: some View {
        Label(title: {Text(title)}, icon:{
            Image(systemName: systemName)
                .foregroundColor(iconColor)
        } )
    }
}

struct ProfileLabel_Previews: PreviewProvider {
    static var previews: some View {
        ProfileLabel(title: "hola", systemName: "person.circle")
    }
}
