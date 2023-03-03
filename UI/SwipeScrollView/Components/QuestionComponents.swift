//
//  QuestionComponents.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/2/23.
//

import SwiftUI

struct QuestionComponents: View {
    
    var index : Int
    @Binding var buttonChoice : Int
    var model : NewUserProfile
 
    @Binding var chosenAnswers : [Int]
    @Binding var chosenQuestions : [String]
    @Binding var leftQuestions : [String]
    @Binding var rightQuestions : [String]
    
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                
                Text(model.ownQuestions[index])
                    .padding(.leading,35)
                    .padding(.trailing,35)
                    .padding(.top,10)
                    .font(.custom("Rubik Regular", size: 16))
                
                ZStack{
                    Rectangle()
                        .frame(width:geo.size.width * 0.65,height: 3)
                    
                    HStack{
                        ForEach(0...4, id: \.self){ index in
                            Button {
                                self.chooseFirstQuestion(index: index)
                            } label: {
                                //                                                Spacer()
                                if buttonChoice == index{
                                    Circle()
                                        .fill(AppColor.lovolOrange)
                                        .frame(width: geo.size.width * 0.15, height: 15)
                                    
                                }
                                else{
                                    Circle()
                                        .fill(AppColor.lovolDarkPurple)
                                        .frame(width: geo.size.width * 0.15, height: 15)
                                    
                                }
                                
                                //                                                Spacer()
                            }
                        }
                        
                    }
                    
                    .padding(.top,10)
                    .padding(.bottom,10)
                }
                
                HStack{
                    Text(model.ownLeftAnswer[index])
                    Spacer()
                    Text(model.ownRightAnswer[index])
                }
                .frame(width:geo.size.width * 0.8)
                
                .font(.custom("Rubik Regular", size: 12))
                .padding(.leading,5)
                .padding(.trailing,5)
                .padding(.bottom, 20)
            }
            
            .foregroundColor(AppColor.lovolDarkPurple)
            
            .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan).frame(width:geo.size.width * 0.9))
            
            .padding(.bottom,5)
        }
    }
    func chooseFirstQuestion(index: Int){
       print("1 tapped")
        self.buttonChoice = index
       chosenAnswers[index] = buttonChoice + 1
       chosenQuestions[index] = model.ownQuestions[index]
       leftQuestions[index] = model.ownLeftAnswer[index]
       rightQuestions[index] = model.ownRightAnswer[index]
   }
}

//struct QuestionComponents_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionComponents()
//    }
//}
