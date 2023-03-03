//
//  InterestButton.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/7/22.
//

import Foundation
import SwiftUI


struct InterestButtonyStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    var isSelected: Bool
    
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 14))
            .foregroundColor(.black)
            .padding(8)
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(configuration.isPressed ? Color.red : Color.black, lineWidth: 2)
            )
            .padding(.top,5)
    }
}

