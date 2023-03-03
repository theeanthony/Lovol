//
//  NotReadyShow.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/20/22.
//

import SwiftUI

struct NotReadyShow: View {
    var body: some View {
        
        GeometryReader { geo in
            VStack{
                Spacer()
                Text("The live show has not started.")
                    .frame(width:250)
                    .font(.custom("Rubik Regular", size: 16))
                    .foregroundColor(AppColor.lovolTan)
                Spacer()
                Button {
                    
                } label: {
                    NavigationLink(destination: SubmitLovolsView()) {
                        Text("Submit lovols")
                            .font(.custom("Rubik Regular", size: 14))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan) .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                            .foregroundColor(AppColor.lovolDarkPurple)
                    }
                    
                }
                Spacer()
            }
        
        .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolDarkPurple).opacity(0.6)
            .frame(width: geo.size.width * 0.95, height:geo.size.height * 0.98))

        .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)
                    }

       
  
           
        
    }
}

struct NotReadyShow_Previews: PreviewProvider {
    static var previews: some View {
        NotReadyShow()
    }
}
