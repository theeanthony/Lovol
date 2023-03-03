//
//  BehindTheSunView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/15/22.
//

import SwiftUI

struct BehindTheSunView: View {
    var body: some View {
        GeometryReader{ geo in
            Group{
                ZStack{
                    Circle().fill(AppColor.lovolDarkPurple)
                        .frame(width:geo.size.width * 0.84, height:geo.size.width * 0.84)
                    Circle().fill(AppColor.lovol1)
                        .frame(width:geo.size.width * 0.81, height:geo.size.width * 0.81)
                    Circle().fill(AppColor.lovol2)
                        .frame(width:geo.size.width * 0.78, height:geo.size.width * 0.78)
                    Circle().fill(.white)
                        .frame(width:geo.size.width * 0.75, height:geo.size.width * 0.75)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolRedPyramid)
                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.15)
                        .rotationEffect(.degrees(-90))
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
//                                .rotationEffect(.degrees(-90))
//
//
//                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.12)
                        .rotationEffect(.degrees(-90))
                        .overlay(
                            ZStack{

                                
                                
                                RoundedRectangle(cornerRadius:10).fill(.white)
                                    .frame(width:geo.size.width * 0.85, height: geo.size.height * 0.12)
                                HStack{
                                    Text("V")
                                        .rotationEffect(.degrees(90))
                                    
                                    Spacer()
                                    Text("L")
                                        .rotationEffect(.degrees(90))
                                }
                                .frame(width:geo.size.width * 0.8, height: geo.size.height * 0.08)
                            }
                                .rotationEffect(.degrees(-90))
                            
                            
                        )
//                    Rectangle()
//                        .fill(AppColor.lovolSendPink)
//                        .frame(width: geo.size.width * 0.7, height: geo.size.height * 0.08)
//                        .rotationEffect(.degrees(-90))
//                        .overlay(
//
//
//                            Rectangle().stroke(.black, lineWidth: 2)
//                                .rotationEffect(.degrees(-90))
//
//                        )
                }
                ZStack{
                    
            
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolRedPyramid)
                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.15)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
//
//                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.12)
                        .overlay(
                            ZStack{
//                                RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
                                   
                                    RoundedRectangle(cornerRadius:10).fill(.white)
                                    
                                .frame(width:geo.size.width * 0.85, height: geo.size.height * 0.12)
                                HStack{
                                    Text("O")

                                    Spacer()
                                    Text("O")
                                }
                                .frame(width:geo.size.width * 0.8, height: geo.size.height * 0.08)
                            }
                            
                        )
//                    Rectangle()
//                        .fill(AppColor.lovolSendPink)
//                        .frame(width: geo.size.width * 0.7, height: geo.size.height * 0.1)
//                        .overlay(
//
//
//                          Rectangle().stroke(.black, lineWidth: 2)
//
//                        )
                }
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolRedPyramid)
                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.15)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
//
//                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolPinkish)
                        .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.12)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
//
//                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(AppColor.lovolSendPink)
                        .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.1)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
//
//                        )
                }
                .rotationEffect(.degrees(-29.5))
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColor.lovolRedPyramid)
                    .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.15)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
//
//                    )
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColor.lovolPinkish)
                    .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.12)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
//
//                    )
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColor.lovolSendPink)
                    .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.10)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
//
//                    )
            }
            .rotationEffect(.degrees(29.5))
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColor.lovolRedPyramid)
                    .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.15)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
//
//                    )
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColor.lovolPinkish)
                    .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.12)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
//
//                    )
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColor.lovolSendPink)
                    .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.10)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
//
//                    )
            }
            .rotationEffect(.degrees(-60.5))
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColor.lovolRedPyramid)
                    .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.15)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
//
//                    )
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColor.lovolPinkish)
                    .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.12)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
//
//                    )
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColor.lovolSendPink)
                    .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.10)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10).stroke(.black, lineWidth: 2)
//
//                    )
            }
            .rotationEffect(.degrees(60.5))
                
                

            }
        .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)
        .font(.custom("Rubik Regular", size: 14))
        .foregroundColor(AppColor.lovolDarkerPurpleBackground)
            
        }
    }
}

struct BehindTheSunView_Previews: PreviewProvider {
    static var previews: some View {
        BehindTheSunView()
    }
}
