//
//  CreateGroupDistanceView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/8/22.
//

import SwiftUI

struct CreateGroupDistanceView: View {
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
    var interactionPreference: Int
    var longitude : Double
    var latitude : Double
    var city: String

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
                        .frame(width: geo.size.width * 0.8, height: geo.size.height * 0.3)                    }
                    
                    
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
                                .frame(width: geo.size.width * 0.7, height: geo.size.height * 0.03)
                                .padding(.horizontal,45)
                                .font(.custom("Rubik Regular", size: 16)).foregroundColor(AppColor.lovolDarkPurple)
                            }
                        }
                        
                        
                        
                        
                    }
                    
                    Button(action:{
                    }, label: {
                        
                        NavigationLink(destination: GroupAgeView(name: name, bio: bio, college: college, occupation: occupation, pictures: pictures, interests: interests, leftAnswers: leftAnswers, rightAnswers: rightAnswers, ownQuestions: ownQuestions, answers: answers, entity: entity, interactionPreference: interactionPreference, longitude: longitude, latitude: latitude, city: city, distance: distance)) {
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
                    LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
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


struct CreateGroupDistanceView_Previews: PreviewProvider {
    @State static var ownLeftExamples : [String] = []
    @State static var ownRightExamples : [String] = []
    @State static var makeOwnQuestion : [String] = []
    @State static var ownAnswers : [Int] = []
    static var previews: some View {
        CreateGroupDistanceView(name: "", bio: "", college: "", occupation: "", pictures: [], interests: [],leftAnswers: ownLeftExamples, rightAnswers: ownRightExamples, ownQuestions: makeOwnQuestion, answers: ownAnswers, entity: 0, interactionPreference: 0,longitude: 0,latitude: 0,city:"")
    }
}
