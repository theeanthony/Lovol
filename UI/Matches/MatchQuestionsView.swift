//
//  MatchQuestionsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/22/22.
//

import SwiftUI

struct MatchQuestionsView: View {
    let matchName: String
    let matchId: String
    
    let matchImage : UIImage
    let mainImage : UIImage
    
    @State private var isLoading = true
//    @State var matchQuestionModel : BothMatchQuestionsModel = BothMatchQuestionsModel(swipeAnswers: [1,2,3,4,5], swipeQuestions: ["D","E","A","B","C"], swipeLeftExamples: ["D","E","A","B","C"], swipeRightExamples: ["D","E","A","B","C"], swipeName: "carol", swipeOwnAnswers: [1,1,1], usersName: "jeff", userAnswers: [1,2,3,4,5], userQuestions: ["D","E","A","B","C"], userLeftExamples: ["D","E","A","B","C"], userRightExamples: ["D","E","A","B","C"], userOwnAnswers: [1,1,1])
    @State var matchQuestionModel : BothMatchQuestionsModel =  BothMatchQuestionsModel(swipeAnswers: [1,2,3,4,5], swipeQuestions: ["D","E","A","B","C"], swipeLeftExamples: ["D","E","A","B","C"], swipeRightExamples: ["D","E","A","B","C"], swipeName: "carol", swipeOwnAnswers: [1,1,1], usersName: "jeff", userAnswers: [1,2,3,4,5], userQuestions: ["D","E","A","B","C"], userLeftExamples: ["D","E","A","B","C"], userRightExamples: ["D","E","A","B","C"], userOwnAnswers: [1,1,1])
    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @State private var oneToSeven: [Int] = [1,2,3,4,5]

    let onSendMessageButtonClicked: () -> ()
    let onKeepSwipingClicked: () -> ()
    
    
    var body: some View {
        VStack{

            ScrollView{
                VStack{
                    if isLoading{
                        ProgressView()
                    }else{
                        VStack{
//                            HStack{
//                                Spacer()
//                                Circle().fill(AppColor.lovolLightPurple)
//                                    .frame(width: 15, height: 15)
//                                Text(matchQuestionModel.usersName)
//                                Spacer()
//                                Circle().fill(AppColor.lovolOrange)
//                                    .frame(width: 15, height: 15)
//                                Spacer()
//                                Text(matchQuestionModel.swipeName)
//                                Circle().fill(AppColor.lovolPinkish)
//                                    .frame(width: 15, height: 15)
//                                Spacer()
//                            }
//                            .padding()
//                            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolPrettyPurple))
//                            .frame(height:100)
//                            .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolTan)

                            Text("Questions by \(matchQuestionModel.usersName)")
                                .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolTan)

                            ForEach(matchQuestionModel.userQuestions.indices, id: \.self){ index in
                                QuestionFormatView(ownQuestionField: matchQuestionModel.userQuestions[index], leftField: matchQuestionModel.userLeftExamples[index], rightField: matchQuestionModel.userRightExamples[index], userAnswer: matchQuestionModel.userAnswers[index], swipeAnswer: matchQuestionModel.swipeOwnAnswers[index], matchImage: matchImage, mainImage: mainImage)
                                    .padding(.vertical,10)
                            }
                            Text("Questions by \(matchQuestionModel.swipeName)")
                                .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolTan)

                            ForEach(matchQuestionModel.swipeQuestions.indices, id: \.self){ index in
                                QuestionFormatView(ownQuestionField: matchQuestionModel.swipeQuestions[index], leftField: matchQuestionModel.swipeLeftExamples[index], rightField: matchQuestionModel.swipeRightExamples[index], userAnswer: matchQuestionModel.swipeAnswers[index], swipeAnswer: matchQuestionModel.userOwnAnswers[index], matchImage: matchImage, mainImage: mainImage)
                                    .padding(.vertical,10)
                            }
                        }
                    }
                  
        
                    }
 
                
            }

            .padding(10)
            Button(action: onSendMessageButtonClicked, label: {
                Text("Send Message").padding([.leading,.trailing], 25).padding([.top, .bottom], 15)
            }).background(AppColor.lovolTan).cornerRadius(25).padding(.top)
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolDarkPurple)
            
            Button(action: onKeepSwipingClicked, label: {
                Text("Keep Swiping").foregroundColor(AppColor.lovolTan)
            }).padding(12)
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
        }
        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .background(LinearGradient(colors: [AppColor.lovolDarkPurple.opacity(0.8), AppColor.lovolPrettyPurple.opacity(0.8),AppColor.lovolPinkish.opacity(0.8)], startPoint: .top, endPoint: .bottom))
        .onAppear(perform: performOnAppear)
        
    }
    func performOnAppear(){

        
        firestoreViewModel.fetchMatchesQuestions(matchId: matchId, userId: profileViewModel.fetchUserId()) { result in

            switch result{
            case .success(let questions):
                matchQuestionModel = questions
                isLoading = false
            case .failure(let error):
                print("Error retrieving matchquestions \(error)")
            }

        }
        
    }
}

struct MatchQuestionsView_Previews: PreviewProvider {
    static var matchQuestionModel = BothMatchQuestionsModel(swipeAnswers: [1,2,3,4,5], swipeQuestions: ["D","E","A"], swipeLeftExamples: ["D","E","A"], swipeRightExamples: ["D","E","A"], swipeName: "carol", swipeOwnAnswers: [1,1,1], usersName: "jeff", userAnswers: [1,2,3,4,5], userQuestions: ["D","E","A"], userLeftExamples: ["D","E","A"], userRightExamples: ["D","E","A"], userOwnAnswers: [1,1,1])
    static var previews: some View {
        MatchQuestionsView(matchName: "Ant", matchId: "123",matchImage: UIImage(named:"elon_musk")!, mainImage: UIImage(named: "jeff_bezos")!, matchQuestionModel: matchQuestionModel, onSendMessageButtonClicked: {}, onKeepSwipingClicked: {})
    }
}
