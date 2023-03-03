//
//  QuestionFormatView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/19/22.
//

import SwiftUI

struct QuestionFormatView: View {
    
    var ownQuestionField : String
    var leftField : String
    var rightField : String
    var userAnswer : Int
    var swipeAnswer : Int
    let matchImage : UIImage
    let mainImage : UIImage
    @State private var oneToFive: [Int] = [1,2,3,4,5]

    var body: some View {

        VStack{
            
            Text(ownQuestionField)
                .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolTan)
                .padding(.horizontal,10)
            ZStack{
                Rectangle().fill(AppColor.lovolTan)
                    .frame(width: 250, height: 3)
                    
                HStack{
                    ForEach(oneToFive.indices, id: \.self){ index in
                        Button {
                        } label: {
                            
                            if(index == userAnswer-1 && index == swipeAnswer-1){
                                ZStack{
                                    Circle()
                                        .fill(AppColor.lovolOrange)
                                        .frame(width: 55, height: 15)
                                    
                                    Image(uiImage: mainImage).centerCropped().frame(width: 30, height: 30).cornerRadius(25)
                                        .background(Circle().stroke(lineWidth:2).fill(AppColor.lovolTan))
                                        .offset(x:10)

                                    Image(uiImage: matchImage).centerCropped().frame(width: 30, height: 30).cornerRadius(25)
                                        .background(Circle().stroke(lineWidth:2).fill(AppColor.lovolTan))
                                        .offset(x:-10)
                                }
                            }
                            else if(index == swipeAnswer-1){
                                ZStack{
                                    Circle()
                                        .fill(AppColor.lovolOrange)
                                        .frame(width: 55, height: 5)
                                    Image(uiImage: matchImage).centerCropped().frame(width: 30, height: 30).cornerRadius(25)
                                        .background(Circle().stroke(lineWidth:2).fill(AppColor.lovolTan))
                               
                                }
                            }
                            else if (index == userAnswer-1){
                                ZStack{
                                    Circle()
                                        .fill(AppColor.lovolOrange)
                                        .frame(width: 55, height: 5)
                                    Image(uiImage: mainImage).centerCropped().frame(width: 30, height: 30).cornerRadius(25)
                                        .background(Circle().stroke(lineWidth:2).fill(AppColor.lovolTan))
                                }
                            }
                            else{
                                Circle()
                                    .fill(AppColor.lovolTan)
                                    .frame(width: 55, height: 15)
                            }
                               
                        }
                    }
                    
                }
             
            }
            VStack{
                HStack{
                    Text(leftField)
                    Spacer()
                    Text(rightField)
                    
                }
                .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolTan)

                
            }
            .padding(.vertical,10)
            .padding(.horizontal,10)
   
        }
        .frame(width:280)
        .padding(10)
        .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolPrettyPurple))
    }
}

struct QuestionFormatView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionFormatView(ownQuestionField: "Question", leftField: "Left field", rightField: "right field", userAnswer: 3, swipeAnswer: 3, matchImage: UIImage(named: "elon_musk")!, mainImage: UIImage(named: "jeff_bezos")!)
    }
}
