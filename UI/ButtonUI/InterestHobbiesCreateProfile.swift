//
//  InterestHobbiesCreateProfile.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/2/22.
//

import SwiftUI
struct InterestButtonyCreateStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .hidden()
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.4)), lineWidth: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.6)))
//                    .shadow(color: Color.black.opacity(1), radius: 1)
            )
//            .opacity(0.7)
            .overlay(configuration.label)
//            .padding(.bottom, 10)
//            .padding(.bottom, 20)
    }
}
struct InterestButtonyCreateFullStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .hidden()
            .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(AppColor.lovolTan, lineWidth: 1)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColor.lovolTan)
//                    .shadow(color: Color.black.opacity(1), radius: 1)
            )
//            .opacity(0.7)
            .overlay(configuration.label)
//            .padding(.bottom, 10)
//            .padding(.bottom, 20)
    }
}
