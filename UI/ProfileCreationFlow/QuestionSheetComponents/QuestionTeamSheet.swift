//
//  QuestionTeamSheet.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/18/23.
//

import SwiftUI

struct QuestionTeamSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        GeometryReader{geo in
            VStack{
                VStack{
                    Image(systemName:"person.3.sequence.fill")
                        .resizable()
                        .frame(width:100,height:60)
                        .foregroundColor(.white)
                    Text("You will need a team to access certain features of the app")
                        .font(.custom("Rubik Regular", size: 18)).foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()

    
//                    Text("I be potato")
//                        .font(.custom("Rubik Regular", size: 18)).foregroundColor(.white)
//                        .padding()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Alright").padding().frame(width:geo.size.width * 0.65).background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                            .font(.custom("Rubik Regular", size: 18)).foregroundColor(.white)
                    }
                    .padding(.vertical)

                    
                }
                .frame(width:geo.size.width * 0.8)
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .frame(width:geo.size.width, height:geo.size.height)
            .background(AppColor.lovolDark)

            
            
        }    }
}

struct QuestionTeamSheet_Previews: PreviewProvider {
    static var previews: some View {
        QuestionTeamSheet()
    }
}
