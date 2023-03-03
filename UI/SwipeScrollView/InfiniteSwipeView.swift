//
//  InfiniteSwipeView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/10/22.
//



import SwiftUI
//
enum SwipeAction{
    case swipeLeft, swipeRight, doNothing
}

struct InfiniteSwipeView: View {
    
    @Binding var profiles: [NewUserProfile]
    @State var swipeAction: SwipeAction = .doNothing
    //Bool: true if it was a like (swipe to the right
    @Binding var showMatchView : Bool
    @Binding var matchName : String
    @Binding var matchImage : UIImage
    @Binding var matchId : String
    @Binding var chosenAnswers : [Int]
    @Binding var chosenQuestions: [String]
    @Binding var leftQuestions : [String]
    @Binding var rightQuestions : [String]
    @Binding var refreshFetch : Bool
    var personalAnswers : [Int]
    var onSwiped: (NewUserProfile, Bool) -> ()
    
    @State private var isShowingUserInitial = false
    @State private var isShowingUser = false
    @State var profileId: String = ""
    @State private var showFillOutAllQuestions : Bool = false
    
    
    var body: some View {
        GeometryReader { geo in

            VStack{
                Spacer()
                VStack{
                        ZStack{
                            
                            Text("no-more-profiles").font(.title3).fontWeight(.medium).foregroundColor(.white).multilineTextAlignment(.center)
                                .padding(.bottom,200)
                                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

                            ForEach(profiles.indices, id: \.self){ index  in
                                VStack{
                                    
                                    let model: NewUserProfile = profiles[index]
                                    if(index == profiles.count - 1){
                                        
                                        InfiniteSwipableCardView(model: model, swipeAction: $swipeAction,chosenAnswers: $chosenAnswers, chosenQuestions:$chosenQuestions,leftQuestions: $leftQuestions, rightQuestions:$rightQuestions, personalAnswers: personalAnswers, onSwiped: performSwipe)
                                        
                                    }
                                    else if(index == profiles.count - 2){
                                        
                                        InfiniteSwipeCardView(model: model, chosenAnswers: $chosenAnswers, chosenQuestions:$chosenQuestions,leftQuestions: $leftQuestions, rightQuestions:$rightQuestions, personalAnswers: personalAnswers, isTestProfile: false)
                                    }
                                }
                                
                                
                            }
                            
                        }

                    .overlay(
                        
                        HStack{
                            //                        Spacer()
                            //                        Button {
                            //
                            //                        } label: {
                            //                            Circle()
                            //                                .fill(AppColor.lovolTan)
                            //                                .frame(width: 45.9, height: 45.9)
                            //                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                            //                                .overlay(
                            //                                    Image(systemName: "backward.fill")
                            //                                        .resizable()
                            //                                        .frame(width: 20.9,
                            //                                               height: 20.9)
                            //                                        .foregroundColor(AppColor.lovolDarkPurple)
                            //
                            //
                            //                                )
                            //                        }
                            Spacer()
                            Button {
                                swipeAction = .swipeLeft
                            } label: {
                                
                                if !profiles.isEmpty {
                                    Image(systemName: "hand.thumbsdown.fill")
                                        .resizable()
                                        .frame(width: 30.9,
                                               height: 30.9)
                                        .foregroundColor(AppColor.lovolTan)
                                    
                                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                                }
                            }
                            Spacer()
                            Button {
                                swipeAction = .swipeRight
                            } label: {
                                if !profiles.isEmpty {
                                    
                                    Image(systemName: "hand.thumbsup.fill")
                                        .resizable()
                                        .frame(width: 30.9,
                                               height: 30.9)
                                        .foregroundColor(AppColor.lovolTan)
                                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                                }
                                
                            }
                            Spacer()
                            
                            //                        Button {
                            //                            //                    swipeAction = .swipeLeft
                            //                        } label: {
                            //                            Circle()
                            //                                .fill(AppColor.lovolTan)
                            //                                .frame(width: 45.9, height: 45.9)
                            //                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                            //                                .overlay(
                            //                                    Image("diamond")
                            //                                        .resizable()
                            //                                        .frame(width: 30.9,
                            //                                               height: 30.9)
                            //                                )
                            //                        }
                            //
                            //
                            //                        Spacer()
                            
                            
                            
                        }.padding(.bottom, 15), alignment: .bottom
                    )
                    
                }

            }
//            .frame(width: geo.size.width * 0.9, height : geo.size.height, alignment: .center )
//            .padding(.horizontal, 2)


        }
        .alert("To like you must fill out all of their questions.", isPresented: $showFillOutAllQuestions, actions: {
            Button("OK", role: .cancel, action: {
                
            })
        })
        .frame(maxWidth:.infinity, maxHeight:.infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
           )

    }
//fetched user id is empty when profile id = profile id in pop up sheet
    private func checkAnswers()->Bool{
        for answer in chosenAnswers {
            if answer == -1 {
                return false
            }
        }
       return true
    }
    
    private func performSwipe(userProfile: NewUserProfile, hasLiked: Bool){
        
        if hasLiked {
            if !checkAnswers() {
                showFillOutAllQuestions = true
                return
            }
            
        }
     
        removeTopItem()

        onSwiped(userProfile, hasLiked)

    }
    
    private func removeTopItem(){
        profiles.removeLast()
        print("Profiles left \(profiles.count)")
        if profiles.count == 1 {
            print("changing refresh")
            self.refreshFetch.toggle()
        }
    }
    
    
}

//struct InfiniteSwipeView_Previews: PreviewProvider {
//
//    static let ownQuestions : [String] = [
//        "Where do I enjoy the room's attention being casted on?",
//        "How often am I on my phone?",
//        "How do I view exercise?",
//        "How do I handle conflict?",
//        "How do I recharge my battery?"
//    ]
//    static let answerToGlobalQuestions : [Int] = [1,1,2,7,7,6,5,4,3,2,2,1,2,3,4,5,5,6,7,7]
//    static let ownLeftQuestions: [String] = ["1 left", "2 left", "3 left", "4 left", "5 left"]
//    static let ownRightQuestions: [String] = ["1 right", "2 right", "3 right", "4 right", "5 right"]
//    static let profile1 =  NewUserProfile(userId: "", name: "Avery", age: 22, bio: "I am a goofy goober hehehe", amountOfUsers: 1, isATeam: false, interests: ["dancing","macaroni?", "eating", "Pooping","Loving","Hackeying"], college: "Santa Clara University", occupation: "Soul Brother", amountOfPeoplePreference: 1, formPreference: 1, genderPreference: 1, interactionPreference: 1, maxDistancePreference: 1, maxYearPreference: 1, minYearPreference: 1, answersToGlobalQuestions: answerToGlobalQuestions, ownQuestions: ownQuestions, ownLeftAnswer: ownLeftQuestions, ownRightAnswer: ownRightQuestions, pictures: [UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!])
//    static let profile2 = NewUserProfile(userId: "", name: "Avery", age: 22, bio: "I am a goofy goober hehehe", amountOfUsers: 1, isATeam: false, interests: ["dancing","macaroni?", "eating", "Pooping","Loving","Hackeying"], college: "Santa Clara University", occupation: "Soul Brother", amountOfPeoplePreference: 1, formPreference: 1, genderPreference: 1, interactionPreference: 1, maxDistancePreference: 1, maxYearPreference: 1, minYearPreference: 1, answersToGlobalQuestions: answerToGlobalQuestions, ownQuestions: ownQuestions, ownLeftAnswer: ownLeftQuestions, ownRightAnswer: ownRightQuestions, pictures: [UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!])
//
//    @State static var profiles : [NewUserProfile] = [profile1, profile2]
//    @State static var showMatchView : Bool = false
//    @State static var matchName : String = "Jeff"
//    @State static var matchImage : UIImage = UIImage(named: "jeff_bezos)")!
//    @State static var matchId : String = ""
////    static var onSwiped = ((NewUserProfile, Bool) -> ()).self
//    static var previews: some View {
//        InfiniteSwipeView(profiles: $profiles, swipeAction: .doNothing, showMatchView: $showMatchView, matchName: $matchName, matchImage: $matchImage, matchId: $matchId, onSwiped: onSwiped(profile1,false))
//    }
//}
