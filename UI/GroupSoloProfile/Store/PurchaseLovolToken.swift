//
//  PurchaseLovolToken.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/18/23.
//

import SwiftUI

struct PurchaseLovolToken: View {
    
    var quantity : Int
   var cost : Int
    var body: some View {
        
        GeometryReader{geo in
            VStack(spacing:0){
                VStack(spacing:0){
                    HStack{
                        Text("+\(quantity)")
                            .font(.custom("Rubik Bold", size: 16)).foregroundColor(.white)

                        Spacer()
                    }
                    .padding(.leading,5)
                    .padding(.bottom,5)
                    Image("logo")
                        .resizable()
                        .frame(width:geo.size.width * 0.5,height:geo.size.width * 0.5)
                }
                .padding(.bottom,5)
                .background(Rectangle().fill(AppColor.lovolPinkish).cornerRadius(10, corners: [.topLeft,.topRight]))
                VStack{
                    HStack{
                       Spacer()
                        lovolBit(height: geo.size.height * 0.1, width: geo.size.width * 0.07)

                        Text("\(cost)")
                            .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)

                        Spacer()
                    }
                }
                .padding(5)
                .background(Rectangle().fill(AppColor.lovolBottomLabelRed).cornerRadius(10,corners:[.bottomLeft,.bottomRight])            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
)
                
            }
            
        }
        
    }
}

struct PurchaseLovolToken_Previews: PreviewProvider {
    static var previews: some View {
        PurchaseLovolToken(quantity: 1, cost: 100)
    }
}
