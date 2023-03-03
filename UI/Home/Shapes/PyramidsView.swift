//
//  PyramidsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/15/22.
//

import SwiftUI

struct PyramidsView: View {
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: -2){
                Group{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.40, height: 12.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.45, height: 12.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.50, height: 12.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.55, height: 12.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.60, height: 12.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.65, height: 12.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.70, height: 12.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
                        )
                }
                Group{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.75, height: 12.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.8, height: 12.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.85, height: 12.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.90, height: 12.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.95, height: 12.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.frame(in: .global).width, height: 12.5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
                        )
                }
                
                
            }
            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

//                            .position(x:geo.frame(in:.global).midX,y:geo.frame(in:.global).minY )

        }
    }
}

struct PyramidsView_Previews: PreviewProvider {
    static var previews: some View {
        PyramidsView()
    }
}
