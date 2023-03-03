//
//  TeamMottoQuestionSheetView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/15/23.
//

import SwiftUI

struct TeamMottoQuestionSheetView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        GeometryReader { geo in

                VStack{
                    VStack{
                        Image(systemName:"camera.macro").resizable()
                            .frame(width:geo.size.width * 0.2, height:geo.size.width * 0.2).foregroundColor(.white)
                        Text("Your team motto describes what drives you and your team.")
                            .font(.custom("Rubik Regular", size: 18)).foregroundColor(.white).multilineTextAlignment(.center)
                            .padding(.vertical)
//                        Text("Choose a motto that will inspire others, and let the rest of the world know what drives your team.")
//                            .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white).multilineTextAlignment(.center)
//                            .frame(width:geo.size.width * 0.6)
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Alright").padding().frame(width:geo.size.width * 0.65).background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                                .font(.custom("Rubik Bold", size: 18)).foregroundColor(.white)
                        }
                        .padding(.vertical)
                    }
                    .frame(width:geo.size.width * 0.7 , height:geo.size.height)
                    
                    
                }
                .frame(width:geo.size.width , height:geo.size.height)
            

        .background(AppColor.lovolDarkerPurpleBackground)

        }
    }
}

struct TeamMottoQuestionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        TeamMottoQuestionSheetView()
    }
}
