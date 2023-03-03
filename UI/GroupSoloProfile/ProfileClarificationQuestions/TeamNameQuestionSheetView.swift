//
//  TeamNameQuestionSheetView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/15/23.
//

import SwiftUI

struct TeamNameQuestionSheetView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        GeometryReader { geo in

                VStack{
                    VStack{
                        Image(systemName:"person.3.fill").resizable()
                            .frame(width:geo.size.width * 0.25, height:geo.size.width * 0.15).foregroundColor(.white)
                        Text("Your team name represents you and your teammates")
                            .font(.custom("Rubik Regular", size: 18)).foregroundColor(.white).multilineTextAlignment(.center)
                            .padding(.vertical)
               
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

struct TeamNameQuestionSheetView_Previews: PreviewProvider {
    static var previews: some View {
        TeamNameQuestionSheetView()
    }
}
