//
//  TeamRuleQuestionView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/15/23.
//

import SwiftUI

struct TeamRuleQuestionView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack{
            GeometryReader { geo in
                VStack{
                    VStack{
                        Image(systemName:"crown.fill").resizable()
                            .frame(width:geo.size.width * 0.1, height:geo.size.width * 0.1).foregroundColor(.white)
                        Text("How will your team run?")
                            .font(.custom("Rubik Bold", size: 16)).foregroundColor(.white).multilineTextAlignment(.center)
                            .padding(.vertical,8)
                        Text("Choose dictator for exclusive control by the person who creates the group.")
                            .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white).multilineTextAlignment(.center)
                            .frame(width:geo.size.width * 0.6)
                            .padding(.vertical,8)
                        Text("Choose democracy for shared control for the whole team.")
                            .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white).multilineTextAlignment(.center)
                            .frame(width:geo.size.width * 0.6)
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Alright").padding().frame(width:geo.size.width * 0.65).background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolTan))
                                .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolDarkPurple)
                        }
                        .padding(.vertical,8)
                    }
                    .frame(width:geo.size.width * 0.7 , height:geo.size.height)
                    
                    
                }
                .frame(width:geo.size.width , height:geo.size.height)
            
            }
        }
        .frame(width:.infinity, height:.infinity)
        .background(AppColor.lovolDarkPurple)
    }
}

struct TeamRuleQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        TeamRuleQuestionView()
    }
}
