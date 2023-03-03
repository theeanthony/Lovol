//
//  FourthCreateView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/6/22.
//

import SwiftUI

struct FourthCreateView: View {
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
    var count: Int
    var questions: [String]
    var name: String
    var pronouns: String
    var bio : String
    var birthDate : Date
    var college : String
   var occupation : String
    @State private var genderOptions = ["female", "male", "trans male", "trans female", "gender non-conforming"]
    @State var gender : String = "female"
    @State var showWarning: Bool = false
//
    var body: some View {
        NavigationStack{
                VStack{
                    VStack{
                        Text("Please choose current gender idenity")
                            .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)
                            .multilineTextAlignment(.center)
                        Picker("Please Choose Current Idenitity", selection: $gender) {
                            ForEach(genderOptions, id: \.self) {
                                Text($0)
//                                Text(LocalizedStringKey($0)).tag($0)
                                    .foregroundColor(AppColor.lovolDarkPurple)
                            }
                            .foregroundColor(AppColor.lovolDarkPurple)
                        }.pickerStyle(WheelPickerStyle()).frame(width: 280, height: 100)
                            .background(AppColor.lovolTan)
                            .cornerRadius(20)
                            .pickerStyle(SegmentedPickerStyle())
                            .foregroundColor(AppColor.lovolDarkPurple)
                            .padding(.horizontal,20)
                            .padding(.bottom,20)
                    }
                        
                    Button(action:{
                        
                    }, label: {
//                        NavigationLink(destination: FifthCreateView(count: count + 1, questions: questions, name: name, pronouns: pronouns, bio: bio, birthDate: birthDate, college: college, occupation: occupation, gender: gender)) {
                        NavigationLink(destination: SixthCreateView(count: count + 1, questions: questions, name: name, pronouns: pronouns, bio: bio, birthDate: birthDate, college: college, occupation: occupation, gender: gender)){
                            
                            Image(systemName:"arrow.right")
                                .centerCropped()
                                .frame(width: 50, height: 40)
                                .foregroundColor(!checkGender() ? AppColor.lovolTan :  Color(#colorLiteral(red: 0.97, green: 0.87, blue: 0.8, alpha: 0.5)))
                            
                        }
                    })
                    .padding()
                    .disabled(checkGender())
                }
            
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Choose Gender Identity")
                       .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .alert("Must choose gender", isPresented: $showWarning, actions: {
                Button("OK", role: .cancel, action: {
                    
                })
            })
        }

    }
    private func checkGender() -> Bool{
        if gender == "" {
//            showWarning = true

            return true
        }
        return false
    }
}

struct FourthCreateView_Previews: PreviewProvider {
    static var previews: some View {
        FourthCreateView(count: 0, questions: [], name: "", pronouns: "", bio: "", birthDate: Date(), college: "", occupation: "")
    }
}
