//
//  ExampleVideoFrame.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/21/22.
//

import SwiftUI

struct ExampleVideoFrame: View {
    @Binding var isPresented : Bool
    var body: some View {
        VStack(spacing:-12){
                HStack{
                    Text("Example")
                        .padding(.bottom,10)
                        .frame(width:85,height:35)
                       
                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolPinkish)          .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolTan))
                    Spacer()
                }
                .frame(width:290)
            ZStack{
                RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolPinkish).frame(width:300,height:160)
                RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolDarkPurple).frame(width:270,height:130)
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName:"play.fill").resizable().foregroundColor(.gray).frame(width:40,height:40)
                }
            }

     
        }
    }
}

struct ExampleVideoFrame_Previews: PreviewProvider {
    @State static var isPresented : Bool = false

    static var previews: some View {
        ExampleVideoFrame(isPresented: $isPresented)
    }
}
