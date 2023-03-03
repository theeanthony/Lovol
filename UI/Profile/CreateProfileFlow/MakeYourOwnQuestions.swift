//
//  QuestionFlow.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/8/22.
//

import SwiftUI

struct MakeYourOwnQuestions: View {
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
    var bio : String
    var pronouns : String
    var birthDate : Date
    var college : String
   var occupation : String
    var gender : String
    var pictures: [UIImage]
    var interests: [String]

    
    var currentValues : [Int]
    var makeQuestionCount : Int
    @Binding var ownLeftExamples : [String]
    @Binding var ownRightExamples : [String]
    @Binding var makeOwnQuestion: [String]
    @Binding var answers : [Int]

    @State private var examplesLeft : [String] = [
    "I am a homebody",  "Everything is predetermined",  "I did not exist", "I would choose to be immortal", "I go with my gut"
    ]
    @State private var examplesRight : [String] = [
        "I go backpacking/camping frequently",  "I write my own future",  "I was waiting to be born", "I am okay with living at most 100 years", "I plan and strategize well in advance"
    ]
    @State private var bothSideQuestions : [String] = [
    "How often am I outside?",
    "Do we have free will",
    "Where was I before I was born",
    "Would I live forever?",
    "How do I make desicions?"
    
    ]
    @State private var oneToFive : [Int] = [1,2,3,4,5]

    @State private var chosenNumber : Int = 0
    @State private var leftField : String = ""
    @State private var rightField : String = ""
    @State private var ownQuestionField: String = ""
    
    @State private var showFinishFields : Bool = false
    @State private var showLoading : Bool = false
    @State private var showError : Bool = false
    private let charLimit: Int = 65
    @State private var toggleSuggestions = false

//    Button(action: submitQuestion) {
//        Text("Finish") == 2
//    }
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                
                //            Text("Make your own questions!")
                //                .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)
                //            Spacer()
                Text("Make your own question! Or choose from suggestions.")
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                    .padding(.horizontal,30)
                    .multilineTextAlignment(.center)
                    .frame(width:geo.size.width * 0.7)
                
                VStack{
                    
                    Text(ownQuestionField)
                        .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolDarkPurple)
                        .padding(.top,10)
                        .padding(.horizontal,10)
                        .frame(width: geo.size.width * 0.6)
                        .multilineTextAlignment(.center)

                    ZStack{
                        Rectangle()
                            .frame(width: geo.size.width * 0.6, height: 3)
                        HStack{
                            ForEach(oneToFive.indices, id: \.self){ index in
                                Button {
                                } label: {
                                    if(index == chosenNumber-1){
                                        Circle()
                                            .fill(AppColor.lovolOrange)
                                            .frame(width: geo.size.width * 0.12, height: 20)
                                    }
                                    else{
                                        Circle()
                                            .fill(AppColor.lovolDarkPurple)
                                            .frame(width: geo.size.width * 0.12, height: 20)
                                    }
                                    
                                }
                            }
                            
                        }
                        //                    .padding(.top,20)
                        //                    .padding(.bottom,10)
                    }
                    VStack{
                        HStack{
                            Text(leftField)
                                .frame(width: geo.size.width * 0.3)

                                .multilineTextAlignment(.center)
                            Spacer()
                            Text(rightField)
                                .frame(width: geo.size.width * 0.3)

                                .multilineTextAlignment(.center)
                            
                        }
                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolDarkPurple)
                        
                        
                    }
                    .padding(.bottom,10)
                    .padding(.horizontal,10)
                    
                }
                .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan))
                .padding(30)
                
                
                VStack(alignment:.center, spacing: 30){
                    
                    HStack{
                        TextField("", text: $ownQuestionField).placeholder(when: ownQuestionField.isEmpty) {
                            Text("Enter Question")
                        }
                        .padding(.leading,5)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onChange(of: ownQuestionField, perform: {newValue in
                            if(newValue.count >= charLimit){
                                ownQuestionField = String(newValue.prefix(charLimit))
                            }
                            
                            
                        })
                        Text("\(charLimit - ownQuestionField.count)").foregroundColor(AppColor.lovolDarkPurple).font(.headline)
                            .padding(.trailing,5)
                        
                    }
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolDarkPurple)
                    
                    .frame(width:250,height:46)
                    .padding(.horizontal,10)
                    .background(RoundedRectangle(cornerRadius: 50)
                        .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8)))
                        .frame(width: 256, height: 46)
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                    //                .padding()
                    
                    HStack{
                        TextField("", text: $leftField).placeholder(when: leftField.isEmpty) {
                            Text("Enter Left Answer")
                        }
                        .padding(.leading,5)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onChange(of: leftField, perform: {newValue in
                            if(newValue.count >= charLimit){
                                leftField = String(newValue.prefix(charLimit))
                            }
                            
                        })
                        Text("\(charLimit - leftField.count)").foregroundColor(AppColor.lovolDarkPurple).font(.headline)
                            .padding(.trailing,5)
                        
                    }
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolDarkPurple)
                    
                    .frame(width:250,height:46)
                    .padding(.leading,5)
                    .background(RoundedRectangle(cornerRadius: 50)
                        .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8)))
                        .frame(width: 256, height: 46)
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                    //                    .padding()
                    HStack{
                        TextField("", text: $rightField).placeholder(when: rightField.isEmpty) {
                            Text("Enter Right Answer")
                        }
                        .padding(.leading,5)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .onChange(of: rightField, perform: {newValue in
                            if(newValue.count >= charLimit){
                                rightField = String(newValue.prefix(charLimit))
                            }
                            
                        })
                        Text("\(charLimit - rightField.count)").foregroundColor(AppColor.lovolDarkPurple).font(.headline)
                            .padding(.trailing,5)
                        
                        
                    }
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolDarkPurple)
                    
                    .frame(width:250,height:46)
                    .padding(.leading,5)
                    .background(RoundedRectangle(cornerRadius: 50)
                        .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8)))
                        .frame(width: 256, height: 46)
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                    //                    .padding()
                    
                    ZStack{
                        Rectangle()
                            .fill(AppColor.lovolDarkPurple)
                            .frame(width: 200, height: 3)
                        
                        HStack{
                            ForEach(oneToFive.indices, id: \.self){ index in
                                Button {
                                    fillButton(chosenNum: index)
                                    
                                } label: {
                                    if(index == chosenNumber-1){
                                        Circle()
                                            .fill(AppColor.lovolOrange)
                                            .frame(width: 40, height: 15)
                                    }
                                    else{
                                        Circle()
                                            .fill(AppColor.lovolDarkPurple)
                                            .frame(width: 40, height: 15)
                                    }
                                }
                            }
                        }
                    }
                    .frame(width:250,height:46)
                    .padding(.leading,5)
                    .background(RoundedRectangle(cornerRadius: 50)
                        .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8)))
                        .frame(width: 256, height: 46)
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                    
                    //                .padding()
                    
                }
                .foregroundColor(AppColor.lovolTan)
                
                
                
                //                    
                //
                
                VStack{
                    Button {
                        toggleSuggestion()
                    } label: {
                        Text("Show Suggestions")
                    }
                    if (toggleSuggestions){
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(examplesLeft.indices, id: \.self) { index in
                                    Button {
                                        
                                        fillQuestions(leftField: examplesLeft[index], rightField: examplesRight[index], bothSides: bothSideQuestions[index])
                                        
                                    } label: {
                                        VStack{
                                            Text("Q: \(bothSideQuestions[index])")
                                            Text("L: \(examplesLeft[index])")
                                            Text("R: \(examplesRight[index])")
                                            
                                        }
                                        .padding(10)
                                        //                                    .frame(alignment:.center)
                                        
                                        
                                    }
                                }
                                
                            }
                            .padding(.vertical,7.0)
                            
                        }
                        .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan))
                        .padding(.horizontal,50)
                        .scrollIndicators(/*@START_MENU_TOKEN@*/.visible/*@END_MENU_TOKEN@*/, axes: /*@START_MENU_TOKEN@*/[.vertical, .horizontal]/*@END_MENU_TOKEN@*/)
                        
                    }
                    
                    
                }
                //
                Spacer()
                if makeQuestionCount == 2 {
                    Button() {
                    } label: {
                        NavigationLink(destination: AvatarHumanPreference(name: name, pronouns: pronouns, bio: bio, birthDate: birthDate, college: college, occupation: occupation, gender: gender,  pictures: pictures, interests: interests, currentValues: currentValues, leftAnswers: ownLeftExamples, rightAnswers: ownRightExamples, ownQuestions: makeOwnQuestion, answers: answers)) {
                            Image(systemName:"arrow.right")
                                .centerCropped()
                                .frame(width: 50, height: 40)
                                .foregroundColor(!checkIfFilled() ? AppColor.lovolTan :    Color(#colorLiteral(red: 0.97, green: 0.87, blue: 0.8, alpha: 0.5)))
                        }
                    }
                    .simultaneousGesture(TapGesture().onEnded{
                        submitQuestion()
                        
                    })
                    .disabled(checkIfFilled())
                }
                if makeQuestionCount < 2 {
                    Button() {
                    } label: {
                        NavigationLink(destination: MakeYourOwnQuestions( questions: questions, name: name, bio: bio, pronouns: pronouns, birthDate: birthDate, college: college, occupation: occupation, gender: gender,  pictures: pictures, interests: interests,  currentValues: currentValues, makeQuestionCount: makeQuestionCount+1, ownLeftExamples: $ownLeftExamples, ownRightExamples: $ownRightExamples, makeOwnQuestion: $makeOwnQuestion, answers: $answers)) {
                            
                            Image(systemName:"arrow.right")
                                .centerCropped()
                                .frame(width: 50, height: 40)
                                .foregroundColor(checkIfFilled() ?  Color(#colorLiteral(red: 0.97, green: 0.87, blue: 0.8, alpha: 0.5)) : AppColor.lovolTan)
                            
                        }
                        .simultaneousGesture(TapGesture().onEnded{
                            submitQuestion()
                            
                        })
                    }
                    .disabled(checkIfFilled())
                }
                
//                    .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

                
                
            }
//            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 1.5)

        }
        .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)

        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
        )
        .navigationBarTitle("")
        .toolbar {
           ToolbarItemGroup(placement: .principal) {
               Text("\(makeQuestionCount+1)/3")
                   .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

           }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
        .showLoading(showLoading)

    

    }
    private func toggleSuggestion(){
        toggleSuggestions.toggle()
    }
    private func checkIfFilled()->Bool{
        if leftField.count == 0 || rightField.count == 0 || chosenNumber == 0 {
            return true
        }
        return false
    }
    private func submitQuestion(){
        self.ownLeftExamples[makeQuestionCount] = leftField
        self.ownRightExamples[makeQuestionCount] = rightField
        self.makeOwnQuestion[makeQuestionCount] = ownQuestionField
        self.answers[makeQuestionCount] = chosenNumber
        
    }
    private func fillQuestions(leftField: String, rightField: String, bothSides: String){
        
        self.leftField = leftField
        self.rightField = rightField
        self.ownQuestionField = bothSides
        toggleSuggestions.toggle()
    }
    private func fillButton(chosenNum: Int){
        self.chosenNumber = chosenNum+1
        
    }
}

struct MakeYourOwnQuestions_Previews: PreviewProvider {
    static let count = 0
    @State static var currentValues : [Int] = []
    @State static var ownLeftExamples : [String] = []
    @State static var ownRightExamples : [String] = []
    @State static var makeOwnQuestions : [String] = []

    @State static var answers : [Int] = []

    static let  examples : [String] = [
        "Example 1", "Example 1", "Example 2", "Example 2", "Example 3", "Example 3","Example 4", "Example 4", "Example 5", "Example 5", "Example 6", "Example 6", "Example 7", "Example 7", "Example 8", "Example 8", "Example 9", "Example 9",
        "Example 10", "Example 10", "Example 11", "Example 11", "Example 12", "Example 12", "Example 13", "Example 13", "Example 14", "Example 14", "Example 15", "Example 15", "Example 16", "Example 16", "Example 17", "Example 17", "Example 18", "Example 18", "Example 19", "Example 19", "Example 20", "Example 20"
        ]
   static let oneToSeven : [Int] = [1,2,3,4,5,6,7]
//    static let chosenNumber = 5

    static var previews: some View {
        MakeYourOwnQuestions( questions: [], name: "", bio: "", pronouns: "", birthDate: Date(), college: "", occupation: "", gender: "",  pictures: [], interests: [], currentValues: currentValues, makeQuestionCount: 0, ownLeftExamples: $ownLeftExamples, ownRightExamples: $ownRightExamples, makeOwnQuestion: $makeOwnQuestions, answers: $answers)
    }
}
