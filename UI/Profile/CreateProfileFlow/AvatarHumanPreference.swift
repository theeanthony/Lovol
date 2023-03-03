//
//  AvatarHumanPreference.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/2/22.
//

import SwiftUI

struct AvatarHumanPreference: View {
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
    @State private var typeOfEntity = 0

//    var questions: [String]
    var name: String
    var pronouns : String
    var bio : String
    var birthDate : Date
    var college : String
   var occupation : String
    var gender : String
    var pictures: [UIImage]
    var interests: [String]
    var currentValues : [Int]
    var leftAnswers : [String]
    var rightAnswers : [String]
    var ownQuestions : [String]
    var answers : [Int]

    var body: some View {
        NavigationStack{
            GeometryReader{ geo in
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColor.lovolTan)
                            .frame(width: geo.size.width * 0.85, height: geo.size.height * 0.25)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        VStack{
                            Text("Choose what you will interact as.")
                                .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                                .padding(.bottom,5)
                            Text("Avatars will participate virtually and only have the chance to match with other Avatars, and or Humans who will only be participating virtually. You cannot change this later.")
                                .font(.custom("Rubik Regular", size: 13)).foregroundColor(AppColor.lovolDarkPurple)
                            
                        }
                        
                        //                        .padding(.horizontal,10)
                        .textInputAutocapitalization(.never)
                        .frame(width: geo.size.width * 0.78, height: geo.size.height * 0.2)                    }
                    
                    .padding()
                    Picker("", selection: $typeOfEntity) {
                        Text("Human").tag(0)
                        
                        Text("Avatar").tag(1)
                    }
                    //                .background(AppColor.lovolTan)
                    .pickerStyle(SegmentedPickerStyle())
                    //                .foregroundColor(AppColor.lovolDarkPurple)
                    .padding(.horizontal,20)
                    
                    Button(action:{
                    }, label: {
                        
                        if typeOfEntity == 0 {
                            NavigationLink(destination: InteractionPreference( name: name, pronouns: pronouns, bio: bio, birthDate: birthDate, college: college, occupation: occupation, gender: gender, pictures: pictures, interests: interests, currentValues: currentValues, leftAnswers: leftAnswers, rightAnswers: rightAnswers, ownQuestions: ownQuestions, answers: answers, typeOfEntity: typeOfEntity)) {
                                Image(systemName:"arrow.right")
                                    .centerCropped()
                                    .frame(width: 50, height: 40)
                                    .foregroundColor(AppColor.lovolTan)
                            }
                        }
                        else if typeOfEntity == 1{
                            NavigationLink(destination: AgePreference(name: name, pronouns: pronouns, bio: bio, birthDate: birthDate, college: college, occupation: occupation, gender: gender,  pictures: pictures, interests: interests, currentValues: currentValues, leftAnswers: leftAnswers, rightAnswers: rightAnswers, ownQuestions: ownQuestions, answers: answers, typeOfEntity: typeOfEntity, interactionPreference: 1, longitude: 0, latitude: 0, city: "Virtual", distance: 0)) {
                                Image(systemName:"arrow.right")
                                    .centerCropped()
                                    .frame(width: 50, height: 40)
                                    .foregroundColor(AppColor.lovolTan)
                            }
                        }
                        else{
                            Image(systemName:"arrow.right")
                                .centerCropped()
                                .frame(width: 50, height: 40)
                                .foregroundColor(AppColor.lovolTan)
                        }
                        
                        
                        
                        
                        
                    })
                    .padding(.top,50)
                    //                .disabled(checkIfName())
                }
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Choose Entity")
                       .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

struct AvatarHumanPreference_Previews: PreviewProvider {
    static var previews: some View {
        AvatarHumanPreference(name: "", pronouns: "", bio: "", birthDate: Date(), college: "", occupation: "", gender: "", pictures: [], interests: [], currentValues: [], leftAnswers: [], rightAnswers: [], ownQuestions: [], answers: [])
    }
}
