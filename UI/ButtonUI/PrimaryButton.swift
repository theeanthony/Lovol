//
//  PrimaryButton.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/19/22.
//


import Foundation
import SwiftUI


struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        Group {
            if isEnabled {
                configuration.label
            } else {
                ProgressView()
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(AppColor.lightCream)
        .cornerRadius(10)
        .animation(.default, value: isEnabled)
    }
}
extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}
