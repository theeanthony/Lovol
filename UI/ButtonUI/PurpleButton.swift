//
//  PurpleButton.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/5/22.
//

import Foundation
import SwiftUI


struct PurpleButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        Group {
            if isEnabled {
                configuration.label
            } else {
                ProgressView()
            }
        }
        .foregroundColor(AppColor.midnightBlue)
        .padding(.horizontal,20)
        .padding(10)
        .background(AppColor.babyBlue)
        .cornerRadius(20)
        .font(
            .custom(
                "Arial", fixedSize: 20)
                .weight(.heavy)
            )
        .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
        .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AppColor.outBlue, lineWidth: 3)
                        .padding(.bottom,4)
                        .scaleEffect(configuration.isPressed ? 0.9 : 1.0)

                )
    }
}
extension ButtonStyle where Self == PurpleButton {
    static var purple: PurpleButton {
        PurpleButton()
    }
}
