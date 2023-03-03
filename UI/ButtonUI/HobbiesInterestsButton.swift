//
//  HobbiesInterestsButton.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/29/22.
//

import SwiftUI

struct InterestHobbiesButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .hidden()
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppColor.lovolOrange, lineWidth: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColor.lovolOrange)
//                    .shadow(color: Color.black.opacity(1), radius: 1)
            )
//            .opacity(0.7)
            .overlay(configuration.label)
//            .padding(.bottom, 10)
//            .padding(.bottom, 20)
    }
}
