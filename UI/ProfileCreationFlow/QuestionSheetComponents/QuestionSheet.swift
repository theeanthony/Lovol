//
//  QuestionSheet.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import SwiftUI

struct QuestionSheet: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        GeometryReader{geo in
            VStack{
                VStack{
                    Image(systemName:"person.fill")
                        .resizable()
                        .frame(width:60,height:60)
                        .foregroundColor(.white)
         

                    Text("Whatever is uploaded has to match every picture you submit in the future for your points to count")
                        .font(.custom("Rubik Regular", size: 18)).foregroundColor(.white)
                        .padding()
                        .multilineTextAlignment(.center)
                        .frame(width:geo.size.width * 0.9)

              
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Alright").padding().frame(width:geo.size.width * 0.65).background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                            .font(.custom("Rubik Regular", size: 18)).foregroundColor(.white)
                    }
                    .padding(.vertical)
                    
                }
                .frame(width:geo.size.width * 0.9)
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .frame(width:geo.size.width, height:geo.size.height)
            .background(AppColor.lovolDark)

            
            
        }
    }
}

struct QuestionSheet_Previews: PreviewProvider {
    static var previews: some View {
        QuestionSheet()
    }
}
