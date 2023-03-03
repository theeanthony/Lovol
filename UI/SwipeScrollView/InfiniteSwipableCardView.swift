//
//  InfiniteSwipableCardView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/10/22.
//

import SwiftUI

struct InfiniteSwipableCardView: View {

    private let nope = "NOPE"
    private let like = "LIKE"
    private let screenWidthLimit = UIScreen.main.bounds.width * 0.5
    @EnvironmentObject var firestoreViewModel : FirestoreViewModel
    let model: NewUserProfile
    @State private var dragOffset = CGSize.zero
    @Binding var swipeAction: SwipeAction
    @Binding var chosenAnswers : [Int]
    @Binding var chosenQuestions: [String]
    @Binding var leftQuestions : [String]
    @Binding var rightQuestions : [String]
    var personalAnswers : [Int]
    var onSwiped: (NewUserProfile, Bool) -> ()
    
    var body: some View {
        InfiniteSwipeCardView(model: model, chosenAnswers: $chosenAnswers, chosenQuestions:$chosenQuestions,leftQuestions: $leftQuestions, rightQuestions:$rightQuestions, personalAnswers: personalAnswers, isTestProfile: false)
                .overlay(
                    HStack{
                        Text(like).font(.largeTitle).bold().foregroundGradient(colors: AppColor.likeColors).padding().overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(LinearGradient(gradient: .init(colors: AppColor.likeColors),
                                                       startPoint: .topLeading,
                                                       endPoint: .bottomTrailing), lineWidth: 4)
                        )
                        .rotationEffect(.degrees(-30)).opacity(getLikeOpacity())
                        Spacer()
                        Text(nope).font(.largeTitle).bold().foregroundGradient(colors: AppColor.dislikeColors).padding().overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(LinearGradient(gradient: .init(colors: AppColor.dislikeColors),
                                                       startPoint: .topLeading,
                                                       endPoint: .bottomTrailing), lineWidth: 4)
                        ).rotationEffect(.degrees(30)).opacity(getDislikeOpacity())

                    }.padding(.top, 45).padding(.leading, 20).padding(.trailing, 20)
                    ,alignment: .top)
       
        
        
            .offset(x: self.dragOffset.width)

            .rotationEffect(.degrees(self.dragOffset.width * -0.06), anchor: .center)

            .simultaneousGesture(DragGesture(minimumDistance: 30.0).onChanged{ value in
                self.dragOffset = value.translation
            }.onEnded{ value in
                performDragEnd(value.translation)
                print("onEnd: \(value.location)")
            })
            .onChange(of: swipeAction, perform: { newValue in
                if newValue != .doNothing {
                    

                    performSwipe(newValue)
              
                }
                
            })
    }
    
    private func performSwipe(_ swipeAction: SwipeAction){
        withAnimation(.linear(duration: 0.3)){
            if(swipeAction == .swipeRight){
                self.dragOffset.width += screenWidthLimit * 2
            } else if(swipeAction == .swipeLeft){
                self.dragOffset.width -= screenWidthLimit * 2
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onSwiped(model, swipeAction == .swipeRight)

        }
        self.swipeAction = .doNothing
    }
    
    private func performDragEnd(_ translation: CGSize){
        let translationX = translation.width
        if(hasLiked(translationX)){
            withAnimation(.linear(duration: 0.3)){
                self.dragOffset = translation
                self.dragOffset.width += screenWidthLimit
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onSwiped(model, true)
            }
        } else if(hasDisliked(translationX)){
            withAnimation(.linear(duration: 0.3)){
                self.dragOffset = translation
                self.dragOffset.width -= screenWidthLimit
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                onSwiped(model, false)
            }
        } else{
            withAnimation(.default){
                self.dragOffset = .zero
            }
        }
    }
    
    private func hasLiked(_ value: Double) -> Bool{
        let ratio: Double = dragOffset.width / screenWidthLimit
        return ratio >= 1
    }
    
    private func hasDisliked(_ value: Double) -> Bool{
        let ratio: Double = -dragOffset.width / screenWidthLimit
        return ratio >= 1
    }
    
    private func getLikeOpacity() -> Double{
        let ratio: Double = dragOffset.width / screenWidthLimit;
        if(ratio >= 1){
            return 1.0
        } else if(ratio <= 0){
            return 0.0
        } else {
            return ratio
        }
    }
    
    private func getDislikeOpacity() -> Double{
        let ratio: Double = -dragOffset.width / screenWidthLimit;
        if(ratio >= 1){
            return 1.0
        } else if(ratio <= 0){
            return 0.0
        } else {
            return ratio
        }
    }
    
}

//struct InfiniteSwipableCardView_Previews: PreviewProvider {
//
//    static let ownQuestions : [String] = [
//        "Where do I enjoy the room's attention being casted on?",
//        "How often am I on my phone?",
//        "How do I view exercise?",
//        "How do I handle conflict?",
//        "How do I recharge my battery?"
//    ]
//    @State static var isShowingUser : Bool = false
//    static let answerToGlobalQuestions : [Int] = [1,1,2,7,7,6,5,4,3,2,2,1,2,3,4,5,5,6,7,7]
//    static let ownLeftQuestions: [String] = ["1 left", "2 left", "3 left", "4 left", "5 left"]
//    static let ownRightQuestions: [String] = ["1 right", "2 right", "3 right", "4 right", "5 right"]
//    static var previews: some View {
//        InfiniteSwipableCardView(model: NewUserProfile(userId: "", name: "Avery", age: 22, bio: "I am a goofy goober hehehe", amountOfUsers: 1, isATeam: false, interests: ["dancing","macaroni?", "eating", "Pooping","Loving","Hackeying"], college: "Santa Clara University", occupation: "Soul Brother", amountOfPeoplePreference: 1, formPreference: 1, genderPreference: 1, interactionPreference: 1, maxDistancePreference: 1, maxYearPreference: 1, minYearPreference: 1, answersToGlobalQuestions: answerToGlobalQuestions, ownQuestions: ownQuestions, ownLeftAnswer: ownLeftQuestions, ownRightAnswer: ownRightQuestions, pictures: [UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!]), index: 2, swipeAction: .constant(.doNothing), isShowingUser: $isShowingUser, onSwiped: { _,_ in
//
//        })
//
//    }
//}
