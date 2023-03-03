//
//  QuestionFlow.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/8/22.
//
 
import SwiftUI

struct QuestionFlow: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(AppColor.lovolTan)
                  
              }
          }
      }
    
    var questions: [String]
    var name: String
    var pronouns :String
    var bio : String
    var birthDate : Date
    var college : String
   var occupation : String
    var gender : String
    var pictures: [UIImage]
    var interests: [String]
//    var exampleCount : Int
    
    @Binding var currentValues : [Int]
    var newCount : Int
    var currentCount : Int
    @State var answers : [Int] = [0,0,0]
    @State var makeQuestionCount : Int = 0

    

//    @State private var questions : [String] = [
//    "Question 1", "Question 2", "Question 3", "Question 4", "Question 5", "Question 6", "Question 7", "Question 8", "Question 9", "Question 10", "Question 11", "Question 12", "Question 13", "Question 14", "Question 15"
//    ]
    @State private var exampleQuestions: [String] = [
    "Where do I enjoy the room's attention being casted on?",
    "How often am I on my phone?",
    "How do I view exercise?",
    "How do I handle conflict?",
    "How do I recharge my battery?",
    "How do I hold onto resentment?",
    "How do I view other people's opinions",
    "How do I go throughout my day?",
    "How do I view the idea of people being imprisoned as a form of punishment?",
    "How do I view other people's opinions about me?",
    "How do I view physical appearances?",
    "Who would I rather surround myself with?",
    "How do I handle peer pressure?",
    "How prevalent is death in my life?",
    "Would I help my best friend get away with murder?"

    ]
    @State private var examples : [String] = [
    "I enjoy being the center of attention", "I enjoy watching the spotlight casted onto someone else",
    "I only use it to text", "I'm scrolling for hours",
    "I exercise frequently and take fitness seriously", "It is not important",
    "I try to avoid conflict", "I confront conflict head on despite it being uncomfortable",
    "I recharge best when I am alone", "I recharge best when I am with other people",
    "I forgive immediately", "I can hold a grudge until I die",
    "I am an open book", "I am a locked safe",
    "I follow a strict schedule", "I go with the flow and do whatever pops up",
    "It is inhumane", "It is efficient",
    "I will change something about myself to fit in", "I don't care about what others think about me",
    "Physical appearance is important to me", "Inside is what matters most",
    "Simple individuals", "Complex individuals",
    "If all my friends were doing it, I would do it", "If I feel strongly about something, I wont let others influence me",
    "I've had people close to me die", "I have not experienced death",
    "I would ask no questions and help them", "I would turn them in",
    "Example 15", "Example 15",
    "Example 16", "Example 16",
    "Example 17", "Example 17",
    "Example 18", "Example 18",
    "Example 19", "Example 19",
    "Example 20", "Example 20"
    ]
    @State private var oneToFive : [Int] = [1,2,3,4,5]
    @State private var ownLeftExamples : [String] = ["","",""]
    @State private var ownRightExamples :  [String] = ["","",""]
    @State private var makeOwnQuestions: [String] = ["","",""]
    @State private var chosenNumber : Int = 0 
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                
                //            Text("\(currentCount+1)/15")
                //                .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)
                Spacer()
                
                if newCount >= 28 {
                    VStack{
                        Text(exampleQuestions[currentCount])
                            .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolDarkPurple)
                            .padding(.top,10)
                            .padding(.horizontal,10)
                        ZStack{
                            Rectangle()
                                .fill(AppColor.lovolDarkPurple)

                                .frame(width: geo.size.width * 0.7, height: 3)
                            HStack{
                                ForEach(oneToFive.indices, id: \.self){ index in
                                    Button {
                                    } label: {
                                        NavigationLink(destination: MakeYourOwnQuestions( questions: questions, name: name, bio: bio, pronouns: pronouns, birthDate: birthDate, college: college, occupation: occupation, gender: gender, pictures: pictures, interests: interests,  currentValues: currentValues, makeQuestionCount: 0, ownLeftExamples: $ownLeftExamples, ownRightExamples: $ownRightExamples, makeOwnQuestion: $makeOwnQuestions, answers: $answers)) {
                                            Circle()
                                                .fill(AppColor.lovolDarkPurple)
                                                .frame(width: geo.size.width * 0.145, height: 20)
                                        }.simultaneousGesture(TapGesture().onEnded{
                                            storeInCurrentValues(current: index)
                                            
                                        })
                                    }
                                }
                                
                            }
                            .padding(.top,20)
                            .padding(.bottom,20)
                        }
                        VStack{
                            HStack{
                                Text(examples[newCount])
                                Spacer()
                                Text(examples[newCount+1])
                                //                                    .padding(.trailing,10)
                                
                            }
                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolDarkPurple)
                            
                            
                        }
                        .padding(.bottom,10)
                        .padding(.horizontal,10)
                        
                    }
                    
                    .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan))
                    .padding(30)
                    Spacer()
                    
                }
                else{
                    
                    VStack{
                        Text(exampleQuestions[currentCount])
                            .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolDarkPurple)
                            .padding(.top,10)
                            .padding(.horizontal,10)
                        ZStack{
                            Rectangle()
                                .fill(AppColor.lovolDarkPurple)
                                .frame(width: geo.size.width * 0.7, height: 3)
                            HStack{
                                ForEach(oneToFive.indices, id: \.self){ index in
                                    Button {
                                    } label: {
                                        NavigationLink(destination: QuestionFlow( questions: questions, name: name, pronouns: pronouns, bio: bio, birthDate: birthDate, college: college, occupation: occupation, gender: gender, pictures: pictures, interests: interests,   currentValues: $currentValues, newCount: newCount+2, currentCount: currentCount+1)) {
                                            Circle()
                                                .fill(AppColor.lovolDarkPurple)
                                                .frame(width: geo.size.width * 0.145, height: 20)
                                        }.simultaneousGesture(TapGesture().onEnded{
                                            storeInCurrentValues(current: index)
                                            
                                        })
                                    }
                                }
                                
                            }
                            .padding(.top,20)
                            .padding(.bottom,20)
                        }
                        VStack{
                            HStack{
                                Text(examples[newCount])
                                Spacer()
                                Text(examples[newCount+1])
                                //                                    .padding(.trailing,10)
                                
                            }
                            .font(.custom("Rubik Regular", size: 10)).foregroundColor(AppColor.lovolDarkPurple)
                            
                            
                        }
                        .padding(.bottom,10)
                        .padding(.horizontal,10)
                        
                    }
                    .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan))
                    .padding(30)
                    Spacer()
                    
                }
            }
        }
        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
        )
        .navigationBarTitle("")
        .toolbar {
           ToolbarItemGroup(placement: .principal) {
               Text("\(currentCount+1)/15")
                   .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

           }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    private func storeInCurrentValues(current: Int){
        print("tapped number")
//        self.currentValues.insert(current, at: currentCount)
        self.currentValues[currentCount] = current + 1
        print(currentValues)


    }
}

struct QuestionFlow_Previews: PreviewProvider {
     static let count = 0
    @State static var currentValues : [Int] = []
    static let  examples : [String] = [
        "Example 1", "Example 1", "Example 2", "Example 2", "Example 3", "Example 3","Example 4", "Example 4", "Example 5", "Example 5", "Example 6", "Example 6", "Example 7", "Example 7", "Example 8", "Example 8", "Example 9", "Example 9",
        "Example 10", "Example 10", "Example 11", "Example 11", "Example 12", "Example 12", "Example 13", "Example 13", "Example 14", "Example 14", "Example 15", "Example 15", "Example 16", "Example 16", "Example 17", "Example 17", "Example 18", "Example 18", "Example 19", "Example 19", "Example 20", "Example 20"
        ]
   static let oneToSeven : [Int] = [1,2,3,4,5,6,7]
//    static let chosenNumber = 5

    static var previews: some View {
        QuestionFlow( questions: [], name: "", pronouns: "", bio: "", birthDate: Date(), college: "", occupation: "", gender: "",  pictures: [], interests: [], currentValues: $currentValues, newCount: 0, currentCount: 0)
    }
}
