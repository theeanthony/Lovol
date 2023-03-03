//
//  EventLabel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/16/22.
//

import SwiftUI

struct EventLabel: View {
    
    let labelHeader : String
    let labelContent : String
    var body: some View {
        
        ZStack{
            
            VStack(spacing: -15){
                HStack{
                    RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolTan)
                        .frame(width: 85, height: 35)
                       
                        .overlay(
                            VStack{
                        
                                Text(labelHeader)
                                    .padding(.top,2)
                                Spacer()
                            }
                            )
                    
                }
                .offset(x: -80)
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolPinkish)
                
                Text(labelContent)
                    .padding()

                    .frame(width:250)
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolPinkish))
                
            
            }
        }
    }
}

struct EventLabel_Previews: PreviewProvider {
    static var previews: some View {
        EventLabel(labelHeader: "Name", labelContent: "Magic Mushrooms ExperienceMagic Mushrooms ExperienceMagic Mushrooms ExperienceMagic Mushrooms ExperienceMagic Mushrooms Experience")
    }
}
