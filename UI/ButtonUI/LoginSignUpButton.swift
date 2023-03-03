//
//  LoginSignUpButton.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/23/22.
//

import Foundation
import SwiftUI

struct LoginSignUpButton: View {

    let action: () -> ()
    let iconName: String
    let input: String


    var body: some View {
        Button(action: action, label: {
            ZStack{
                RoundedRectangle(cornerRadius: 40)
                    .fill(AppColor.lovolTan)
                .frame(width: 310, height: 45)
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                HStack{
                    Image(systemName: iconName).font(.system(size: 15, weight: .bold)).foregroundColor(AppColor.lovolDarkPurple)
                    Text(input).foregroundColor(AppColor.lovolDarkPurple)
                }
            }

        })
        .padding(10)
    }
}

struct LoginSignUpButton_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignUpButton(action: {
            print("It works!")
        },iconName: "heart", input: "Sign In")
    }
}
//struct LoginSignUpButton: ButtonStyle {
////    @Environment(\.isEnabled) private var isEnabled
//    let action: () -> ()
//    let iconName: String
//    let input : String
//
//    func makeBody(configuration: Configuration) -> some View {
////        Group {
////            if isEnabled {
////                configuration.label
////            } else {
////                ProgressView()
////            }
////        }
//        .foregroundColor(AppColor.lovolBlue)
//        .padding(.horizontal,20)
//        .padding(10)
//        .background(AppColor.cream)
//        .cornerRadius(40)
//        .shadow(color: Color(#colorLiteral(red:0,green:0,blue:0, alpha: 0.25)), radius: 4, x:0, y:4)
//        .font(
//            .custom(
//                "Source Sans Pro", fixedSize: 15)
//            .weight(.medium)
//            )
//        .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
////        .overlay(
////                    RoundedRectangle(cornerRadius: 40)
////                        .stroke(AppColor.outBlue, lineWidth: 3)
////                        .padding(.bottom,4)
////                        .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
////
////                )
//    }
//}
//extension ButtonStyle where Self == LoginSignUpButton {
//    static var LoginSignUp: LoginSignUpButton {
//                LoginSignUpButton(action: {
//                    print("It works!")
//                },iconName: "heart", input: "Sign In")
//
//    }
//}
//struct GradientOutlineButton_Previews: PreviewProvider {
//    static var previews: some View {
//        GradientOutlineButton(action: {
//            print("It works!")
//        },iconName: "heart", colors: [Color(red: 232/255, green: 57/255, blue: 132/255), Color(red: 244/255, green: 125/255, blue: 83/255)])
//    }
//}
