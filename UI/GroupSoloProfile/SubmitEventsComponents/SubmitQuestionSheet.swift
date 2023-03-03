//
//  SubmitQuestionSheet.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/31/23.
//

import SwiftUI

struct SubmitQuestionSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        GeometryReader{geo in
            HStack{
                Spacer()
                VStack{
                    Spacer()
                    Image(systemName:"plus.circle")
                        .resizable()
                        .frame(width:geo.size.height * 0.1, height:geo.size.height * 0.1)
                        .foregroundColor(.white)
                    Spacer()
                    Text("You need exactly 100 lovol bits to receive 1 Lovol. However many you exchange, your Lovols will be entered as a raffle or raffles.")
                        .padding()
                    Text("Teams will be chosen pulling from the Lovol pool, so the more Lovols you have, the higher the chance you have for being chosen.")
                        .padding()
                         Text("Once you make the exchange, if you are not chosen, you lose your Lovols. You can save your lovol bits for future rounds.")
                    
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Alright")
                            .frame(width:geo.size.width * 0.6)
                            .padding()
                            .font(.custom("Rubik Bold", size: 16)).foregroundColor(.white)
                            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolPinkish))
                    }

                    
                }
                        .multilineTextAlignment(.center)
                       .frame(width:geo.size.width * 0.9)
                       .font(.custom("Rubik Regular", size: 18)).foregroundColor(.white)
                Spacer()

            }
            .background(AppColor.lovolDarkerPurpleBackground)
        }
        
    }
}

struct SubmitQuestionSheet_Previews: PreviewProvider {
    static var previews: some View {
        SubmitQuestionSheet()
    }
}
