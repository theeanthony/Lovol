//
//  lovolBit.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/18/23.
//

import SwiftUI


//struct LovolBits : Shape{
//    func path(in rect: CGRect) -> Path {
//           var path = Path()
//
//           path.move(to: CGPoint(x: rect.midX, y: rect.minY))
//           path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
//           path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//           path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
//
//           return path
//       }
//}
struct lovolBit: View {
    let height : CGFloat
    let width : CGFloat
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolOrange).frame(width:width/5,height:height)
            Circle().fill(AppColor.lovolDarkPurple).frame(width:width,height:width)
         
        }
    }
}

struct lovolBit_Previews: PreviewProvider {
    static var previews: some View {
        lovolBit(height: 100, width: 50)
    }
}
