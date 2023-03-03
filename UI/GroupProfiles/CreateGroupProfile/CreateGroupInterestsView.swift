//
//  CreateGroupInterestsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/8/22.
//

import SwiftUI

struct CreateGroupInterestsView: View {
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
    @State var currentValues : [Int] = [0,0,0]
    @State var newCount: Int = 0
    @State var interests: [String] = []
    @State var jsonInterestHolder : [InterestsModel] = []
    @State var showWarning : Bool = false
    @State var showNeedMoreInterests : Bool = false
    @State var canContinue : Bool = false
    @State private var oneToFive : [Int] = [1,2,3,4,5]
    @State private var ownLeftExamples : [String] = ["","",""]
    @State private var ownRightExamples :  [String] = ["","",""]
    @State private var makeOwnQuestions: [String] = ["","",""]
    @State private var ownAnswers: [Int] = [0,0,0]
    @State private var chosenNumber : Int = 0
    @State private var makeQuestionCount : Int = 0
    
    @State var tagCount = 0
    let newColumns = [
       
        GridItem(.adaptive(minimum: 150, maximum: 300)),
        GridItem(.adaptive(minimum: 150, maximum: 300)),
        GridItem(.adaptive(minimum: 150, maximum: 300))


     ]
    let rows = [
        GridItem(.fixed(6))
    ]

    
    var body: some View {
        NavigationStack{

                
                VStack{
                    VStack{

                        LazyVGrid(columns: newColumns, spacing: 10){
                            ForEach(interests.indices, id: \.self) { item in
                                Button {
                                    storeInterest(interest: interests[item])
                                } label: {
                                    Text(interests[item])
                                        .font(.custom("Rubik", size: 12)).foregroundColor(AppColor.lovolDarkPurple)
                                        .padding(1)
                                }
                                .buttonStyle(InterestButtonyCreateFullStyle())
                                
                            }
                            
                        }
                        .padding(10)
                    }
                    ScrollView{

                    ForEach(jsonInterestHolder.indices, id: \.self) { index in
                        VStack{
                            ProfileSection(jsonInterestHolder[index].category){
                                
                                VStack{
                                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 20)],spacing: 12) {
                                        ForEach(jsonInterestHolder[index].specifics, id: \.self) { item in
                                            
                                            if interests.contains(item){
                                                Button {
                                                    storeInterest(interest: item)
                                                } label: {
                                                    Text(item)
                                                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolDarkPurple)
                                                        .padding(1)
                                                }
                                                .buttonStyle(InterestButtonyCreateFullStyle())

                                            }
                                            else{
                                                Button {
                                                    storeInterest(interest: item)
                                                } label: {
                                                    Text(item)
                                                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolDarkPurple)
                                                        .padding(1)
                                                }
                                                .buttonStyle(InterestButtonyCreateStyle())
                                            }
                                        }
                                        
                                    }
                                    .padding(10)
                                    
                                }
                                .padding(.top, 15)
                                .padding(.bottom, 10)
                            }
                            
                        }
                        
                    }
                    

                    
                }
    

                    Button(action:{
                    }, label: {
                        NavigationLink(destination: CreateGroupQuestionsView(name: name, bio: bio, college:college, occupation:occupation, pictures: pictures, interests: interests,  makeQuestionCount:makeQuestionCount, ownLeftExamples: $ownLeftExamples, ownRightExamples: $ownRightExamples, makeOwnQuestion: $makeOwnQuestions, ownAnswers: $ownAnswers)) {
                            
                            Image(systemName:"arrow.right")
                                .centerCropped()
                                .frame(width: 50, height: 40)
                            .foregroundColor(!checkForMinimumInterests() ? AppColor.lovolTan : Color(#colorLiteral(red: 0.97, green: 0.87, blue: 0.8, alpha: 0.5)))}
                    })
                    .disabled(checkForMinimumInterests())
//                    .padding(.top, 20)
                    .padding(.vertical,15)

                            


                    }
                        .padding(.top, 10)

                        .frame(maxWidth:.infinity,maxHeight:.infinity)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
                        )
                        .navigationBarTitle("")
                        .toolbar {
                           ToolbarItemGroup(placement: .principal) {
                               Text("Choose Interests/Hobbies")
                                   .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

                           }
                        }
                        .navigationBarBackButtonHidden(true)
                        .navigationBarItems(leading: btnBack)
                        .navigationBarTitleDisplayMode(.inline)
                
 
                .alert("Need at least 3 interests", isPresented: $showNeedMoreInterests, actions: {
                    Button("OK", role: .cancel, action: {
                        
                    })
                })
      
        }
        .onAppear(perform: performOnAppear)
    }
    private func checkForMinimumInterests() -> Bool{
        if interests.count < 3 || interests.count > 6 {
            return true
        }
        return false


    }

    private func storeInterest(interest: String){
        var currentIndex = 0


        for item in interests
        {
            if item == interest {
                interests.remove(at: currentIndex)
                return
            }
            currentIndex += 1
        }
        if interests.count > 5 {
            return
        }
        

        interests.append(interest)
    }
    private func performOnAppear(){
        
        jsonInterestHolder = loadInterestJson()

    }

}

struct CreateGroupInterestsView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupInterestsView(name: "", bio: "", college: "", occupation: "", pictures: [])
    }
}
