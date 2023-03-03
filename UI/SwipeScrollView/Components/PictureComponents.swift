//
//  PictureComponents.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/2/23.
//

import SwiftUI

struct PictureComponents: View {
    
    let model : NewUserProfile
    let index : Int
    
    var body: some View {
        
        GeometryReader { geo in
            ZStack{
                Image(uiImage: model.pictures[index])
                    .centerCropped()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 300, height: 500)
//                    .frame(width:geo.size.width * 0.9, height: geo.size.height * 0.9)
//                    .position(x:geo.frame(in:.global).midX,y:geo.frame(in:.global).midY)

                    .clipShape(RoundedRectangle(cornerRadius: 20))
                //                                    .frame(width: geo.size.width * 0.85, height: 500)
//                    .frame(width:geo.size.width * 0.9, height: geo.size.height * 0.9)
//                    .position(x:geo.frame(in:.global).midX,y:geo.frame(in:.global).midY)

            }
        }
    }
}

struct PictureComponents_Previews: PreviewProvider {
    static let ownQuestions : [String] = [
        "Where do I enjoy the room's attention being casted on?",
        "How often am I on my phone?",
        "How do I view exercise?",
        "How do I handle conflict?",
        "How do I recharge my battery?"
    ]
    static let answerToGlobalQuestions : [Int] = [1,1,2,5,5,2,5,4,3,2,2,1,2,3,4,5,5,1,1,1]
    static let answerToGlobalQuestions1 : [Int] = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
    static let answerToGlobalQuestions2: [Int] = [1,1,2,4,4,4,5,4,3,2,2,4,2,3,4,5,5,3,3,4]
    static let answerToGlobalQuestions3 : [Int] = [1,1,2,1,2,2,5,4,3,2,2,1,2,3,4,5,5,3,3,2]

    static let ownLeftQuestions: [String] = ["1 left", "2 left", "3 left", "4 left", "5 left"]
    static let ownRightQuestions: [String] = ["1 right", "2 right", "3 right", "4 right", "5 right"]
    @State static var chosenAnswers : [Int] = []
    @State static var chosenQuestions: [String] = []
    @State static var leftQuestions: [String] = []
    @State static var rightQuestions: [String] = []
    static let nameAndPic : [NameAndProfilePic] = [NameAndProfilePic(names: "anthony",pictures: UIImage(named:"elon_musk")!,bio:"I LIke to eat pooop", answers: answerToGlobalQuestions),NameAndProfilePic(names: "tony",pictures: UIImage(named:"elon_musk")!, bio: "I do nt like to eat poop", answers: answerToGlobalQuestions1),NameAndProfilePic(names: "anthony",pictures: UIImage(named:"elon_musk")!,bio:"I LIke to eat pooop", answers: answerToGlobalQuestions2),NameAndProfilePic(names: "tony",pictures: UIImage(named:"elon_musk")!, bio: "I do nt like to eat poop", answers: answerToGlobalQuestions3),NameAndProfilePic(names: "anthony",pictures: UIImage(named:"elon_musk")!,bio:"I LIke to eat pooop", answers: answerToGlobalQuestions2),NameAndProfilePic(names: "tony",pictures: UIImage(named:"elon_musk")!, bio: "I do nt like to eat poop", answers: answerToGlobalQuestions)]
    static var previews: some View {
        PictureComponents(model: NewUserProfile(userId: "", name: "Annabelle", age: 22, bio: "I am a goofy goober hehehe", amountOfUsers: 6, isATeam: true, interests: ["snowboarding!!","snowboarding!!?", "snowboarding!!", "snowboarding!!","snowboarding!!","snowboarding!!"], college: "Santa Clara University", occupation: "Soul Brother", formPreference: 1, interactionPreference: 1, maxDistancePreference: 1, maxYearPreference: 1, minYearPreference: 1, answersToGlobalQuestions: answerToGlobalQuestions, ownQuestions: ownQuestions, ownLeftAnswer: ownLeftQuestions, ownRightAnswer: ownRightQuestions, pictures: [UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!,UIImage(named: "elon_musk")!,UIImage(named: "jeff_bezos")!], nameAndPic: nameAndPic, city: "Virtual"), index : 0)
    }
}
