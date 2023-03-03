//
//  CreateGroupInteractionView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/8/22.
//

import SwiftUI

struct CreateGroupInteractionView: View {
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
    var leftAnswers : [String]
    var rightAnswers : [String]
    var ownQuestions : [String]
    var answers : [Int]
    var entity: Int
    
    @State private var interactionPreference = 0

    var body: some View {
        NavigationStack{
            GeometryReader { geo in
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 30)
                            .fill(AppColor.lovolTan)
                            .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.25)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        VStack{
                            Text("Choose how your team will interact.")
                                .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                                .padding(.bottom,5)
                            Text("By choosing Virtual, you will also be shown Avatar accounts.")
                                .font(.custom("Rubik Regular", size: 13)).foregroundColor(AppColor.lovolDarkPurple)
                            
                        }
                        
                        //                        .padding(.horizontal,10)
                        .padding(20)
                        .textInputAutocapitalization(.never)
                        .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.3)                }
                    
                    Picker("", selection: $interactionPreference) {
                        Text("Physical").tag(0)
                        
                        Text("Virtual").tag(1)
                    }
                    //                .background(AppColor.lovolTan)
                    .pickerStyle(SegmentedPickerStyle())
                    //                .foregroundColor(AppColor.lovolDarkPurple)
                    .padding(.horizontal,20)
                    
                    Button(action:{
                    }, label: {
                        
                        if interactionPreference == 0 {
                            NavigationLink(destination: CreateGroupDestinationView(name: name, bio: bio, college: college, occupation: occupation, pictures: pictures, interests: interests, leftAnswers: leftAnswers, rightAnswers: rightAnswers, ownQuestions: ownQuestions, answers: answers, entity: entity, interactionPreference: interactionPreference)) {
                                Image(systemName:"arrow.right")
                                    .centerCropped()
                                    .frame(width: 50, height: 40)
                                    .foregroundColor(AppColor.lovolTan)
                            }
                        }
                        else{
                            NavigationLink(destination: GroupAgeView(name: name, bio: bio, college: college, occupation: occupation, pictures: pictures, interests: interests, leftAnswers: leftAnswers, rightAnswers: rightAnswers, ownQuestions: ownQuestions, answers: answers, entity: entity, interactionPreference: interactionPreference, longitude: 0, latitude: 0, city: "Virtual", distance: 0)) {
                                Image(systemName:"arrow.right")
                                    .centerCropped()
                                    .frame(width: 50, height: 40)
                                    .foregroundColor(AppColor.lovolTan)
                            }
                        }
                        
                        
                        
                        
                    })
                    .padding(.top,50)
                    //                .disabled(checkIfName())
                }
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Choose Interaction")
                       .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct CreateGroupInteractionView_Previews: PreviewProvider {
    @State static var ownLeftExamples : [String] = []
    @State static var ownRightExamples : [String] = []
    @State static var makeOwnQuestion : [String] = []
    @State static var ownAnswers : [Int] = []
    static var previews: some View {
        CreateGroupInteractionView(name: "", bio: "", college: "", occupation: "", pictures: [], interests: [],leftAnswers: ownLeftExamples, rightAnswers: ownRightExamples, ownQuestions: makeOwnQuestion, answers: ownAnswers, entity: 0)
    }
}
 
