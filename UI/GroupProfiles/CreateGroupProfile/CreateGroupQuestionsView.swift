//
//  CreateGroupQuestionsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/8/22.
//

import SwiftUI

struct CreateGroupQuestionsView: View {
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
    var name: String
    var bio : String
    var college : String
   var occupation : String
    var pictures: [UIImage]
    var interests: [String]

    
    var makeQuestionCount : Int
    @Binding var ownLeftExamples : [String]
    @Binding var ownRightExamples : [String]
    @Binding var makeOwnQuestion: [String]
    @Binding var ownAnswers : [Int]


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
//
//                //            Text("Make your own questions!")
//                //                .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)
//                //            Spacer()
//                Text("Make your own question! Or choose from suggestions.")
//                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
//                    .padding(.horizontal,30)
//                    .multilineTextAlignment(.center)
//                    .frame(width:geo.size.width * 0.7, height: 20)
                
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
                        ScrollView{

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
                }
                //
                Spacer()
                if makeQuestionCount == 2 {
                    Button() {
                    } label: {
                        NavigationLink(destination: CreateGroupAvatarView(name: name, bio: bio, college: college, occupation: occupation, pictures: pictures, interests: interests, leftAnswers: ownLeftExamples, rightAnswers: ownRightExamples, ownQuestions: makeOwnQuestion, answers: ownAnswers)) {
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
                    .padding(.bottom,20)
                }
                else{
                    Button() {
                    } label: {
                        NavigationLink(destination: CreateGroupQuestionsView(name: name, bio: bio, college:college, occupation:occupation, pictures: pictures, interests: interests, makeQuestionCount:makeQuestionCount+1, ownLeftExamples: $ownLeftExamples, ownRightExamples: $ownRightExamples, makeOwnQuestion: $makeOwnQuestion, ownAnswers: $ownAnswers)) {
                            
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
                    .padding(.bottom,20)

                }
                
//                    .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

                
                
            }

        }
        .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)

        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
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
        
//        if(checkIfFilled()){
//            print("IN HERE IN HERE")
//            return
//        }

        
        self.ownLeftExamples[makeQuestionCount] = leftField
        self.ownRightExamples[makeQuestionCount] = rightField
        self.makeOwnQuestion[makeQuestionCount] = ownQuestionField
        self.ownAnswers[makeQuestionCount] = chosenNumber
        
        if makeQuestionCount == 2 {
            showLoading = true

        }
        
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

struct CreateGroupQuestionsView_Previews: PreviewProvider {
    @State static var ownLeftExamples : [String] = []
    @State static var ownRightExamples : [String] = []
    @State static var makeOwnQuestion : [String] = []
    @State static var ownAnswers : [Int] = []

    static var previews: some View {
        CreateGroupQuestionsView(name: "", bio: "", college: "", occupation: "", pictures: [], interests: [], makeQuestionCount: 0, ownLeftExamples: $ownLeftExamples, ownRightExamples: $ownRightExamples, makeOwnQuestion: $makeOwnQuestion, ownAnswers: $ownAnswers)
    }
}
