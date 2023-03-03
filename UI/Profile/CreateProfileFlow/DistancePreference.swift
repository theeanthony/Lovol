//
//  DistancePreference.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/3/22.
//

import SwiftUI

struct DistancePreference: View {
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
    @State private var distance: Double = 25
    var name: String
    var pronouns: String 
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
    var typeOfEntity : Int
    var interactionPreference : Int
    var longitude : Double
    var latitude : Double
    var city : String
    
    var body: some View {
        NavigationStack{
            GeometryReader {geo in
                VStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppColor.lovolTan)
                            .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.1)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        VStack{
                            Text("Set Distance Preference.")
                                .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                                .padding(.bottom,5)
                            
                        }
                        
                        .padding(20)
                        .textInputAutocapitalization(.never)
                        .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.2)                    }
                    
                    
                    VStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppColor.lovolTan)
                                .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.2)
                                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                            VStack{
                                Text("Max Distance: \(String(format: "%.0f", distance))")
                                    .font(.custom("Rubik Bold", size: 18)).foregroundColor(AppColor.lovolDarkPurple)
                                    .padding(.bottom,10)
                                SliderView1(value: $distance)
                                    .frame(width: geo.size.width * 0.75, height: geo.size.height * 0.03)
                                HStack{
                                    Text("1")
                                    Spacer()
                                    Text("50")
                                }
                                .padding(.horizontal,45)
                                .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                            }
                        }
                        
                        
                        
                        
                    }
                    
                    Button(action:{
                    }, label: {
                        
                        NavigationLink(destination: AgePreference(name: name, pronouns: pronouns, bio: bio, birthDate: birthDate, college: college, occupation: occupation, gender: gender,  pictures: pictures, interests: interests, currentValues: currentValues, leftAnswers: leftAnswers, rightAnswers: rightAnswers, ownQuestions: ownQuestions, answers: answers, typeOfEntity: typeOfEntity, interactionPreference: interactionPreference, longitude: longitude, latitude: latitude, city: city, distance: distance)) {
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
                   Text("Choose Distance")
                       .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DistancePreference_Previews: PreviewProvider {
    static var previews: some View {
        DistancePreference(name: "", pronouns: "", bio: "", birthDate: Date(), college: "", occupation: "", gender: "",  pictures: [], interests: [], currentValues: [], leftAnswers: [], rightAnswers: [], ownQuestions: [], answers: [], typeOfEntity: 0, interactionPreference: 0, longitude: 0, latitude: 0, city: "")
    }
}
