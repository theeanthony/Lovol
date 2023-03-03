//
//  EditQuestions.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/7/22.
//

import SwiftUI

struct EditQuestions: View {
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
    @Binding var ownQuestions : [String]
    @Binding var leftAnswers : [String]
    @Binding var rightAnswers : [String]
    @Binding var answers : [Int]
    private let charLimit: Int = 65
    @State private var oneToFive : [Int] = [1,2,3,4,5]
    @State private var tempQuestions : [String] = ["","",""]
    @State private var tempLeftAnswers : [String] = ["","",""]
    @State private var tempRightAnswers : [String] = ["","",""]
    @State private var tempAnswers : [Int] = [0,0,0] 

    

    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    VStack{
                        ForEach(ownQuestions.indices, id: \.self){
                            index in
                            VStack{
                                Text(tempQuestions[index])
                                    .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolDarkPurple)
                                    .padding(.top,10)
                                    .padding(.horizontal,10)
                                    .frame(width:230)
                                
                                ZStack{
                                    Rectangle()
                                        .frame(width: 245, height: 3)
                                        .foregroundColor(AppColor.lovolDarkPurple)
                                    HStack{
                                        ForEach(oneToFive.indices, id: \.self){ answer in
                                            Button {
                                            } label: {
                                                if(answer == tempAnswers[index]-1){
                                                    Circle()
                                                        .fill(AppColor.lovolOrange)
                                                        .frame(width: 50, height: 15)
                                                }
                                                else{
                                                    Circle()
                                                        .fill(AppColor.lovolDarkPurple)
                                                        .frame(width: 50, height: 15)
                                                }
                                                   
                                            }
                                        }
                                        
                                    }
                                    .padding(.top,20)
                                    .padding(.bottom,20)
                                }
                                VStack{
                                    HStack{
                                        Text(tempLeftAnswers[index])
                                        Spacer()
                                        Text(tempRightAnswers[index])
                                        
                                    }
                                    .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolDarkPurple)
                                    .frame(width:250)

                                    
                                }
                                .padding(.bottom,10)
                                .padding(.horizontal,10)
                       
                            }
                            .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan))
                            .padding(30)
                            VStack(alignment:.center){
                                        
                                HStack{
                                    TextField("", text: $tempQuestions[index]).placeholder(when: tempQuestions[index].isEmpty) {
                                        Text("Enter Question")
                                    }
                                        .padding(.leading,5)
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .onChange(of: tempQuestions[index], perform: {newValue in
                                            if(newValue.count >= charLimit){
                                                tempQuestions[index] = String(newValue.prefix(charLimit))
                                            }
                                            
                 
                                        })
                                    Text("\(charLimit - tempQuestions[index].count)").foregroundColor(AppColor.lovolDarkPurple).font(.headline)
                                        .padding(.trailing,5)

                                }
                                .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolDarkPurple)

                                .frame(width:250,height:46)
                                .padding(.horizontal,10)
                                .background(RoundedRectangle(cornerRadius: 50)
                                    .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8)))
                                    .frame(width: 256, height: 46)
                                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                                .padding()
                                
                                HStack{
                                    TextField("", text: $tempLeftAnswers[index]).placeholder(when: tempLeftAnswers[index].isEmpty) {
                                        Text("Enter Left Answer")
                                    }
                                        .padding(.leading,5)
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .onChange(of: tempLeftAnswers[index], perform: {newValue in
                                            if(newValue.count >= charLimit){
                                                tempLeftAnswers[index] = String(newValue.prefix(charLimit))
                                            }
                 
                                        })
                                    Text("\(charLimit - tempLeftAnswers[index].count)").foregroundColor(AppColor.lovolDarkPurple).font(.headline)
                                        .padding(.trailing,5)

                                }
                                .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolDarkPurple)

                                    .frame(width:250,height:46)
                                    .padding(.leading,5)
                                    .background(RoundedRectangle(cornerRadius: 50)
                                        .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8)))
                                    .frame(width: 256, height: 46)
                                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                                    .padding()
                                HStack{
                                    TextField("", text: $tempRightAnswers[index]).placeholder(when: tempRightAnswers[index].isEmpty) {
                                        Text("Enter Right Answer")
                                    }
                                        .padding(.leading,5)
                                        .textInputAutocapitalization(.never)
                                        .disableAutocorrection(true)
                                        .onChange(of: tempRightAnswers[index], perform: {newValue in
                                            if(newValue.count >= charLimit){
                                                tempRightAnswers[index] = String(newValue.prefix(charLimit))
                                            }
                 
                                        })
                                    Text("\(charLimit - tempRightAnswers[index].count)").foregroundColor(AppColor.lovolDarkPurple).font(.headline)
                                        .padding(.trailing,5)


                                }
                                .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolDarkPurple)

                                    .frame(width:250,height:46)
                                    .padding(.leading,5)
                                    .background(RoundedRectangle(cornerRadius: 50)
                                        .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8)))
                                    .frame(width: 256, height: 46)
                                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                                    .padding()

                                ZStack{
                                    Rectangle()
                                        .fill(AppColor.lovolDarkPurple)
                                        .frame(width: 200, height: 3)
                                        
                                    HStack{
                                        ForEach(oneToFive.indices, id: \.self){ answer in
                                            Button {
                                                fillButton(chosenNum: answer, index: index)

                                            } label: {
                                                if(answer == tempAnswers[index]-1){
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

                                .padding()

                                }
                            
                        }

                    }
                }


                Button {
                    
                } label: {
                    Text("done")
                }

                        
        
                            



            }
            .onAppear(perform: fillQuestions)
            .font(.custom("Rubik Regular", size: 12)).foregroundColor(AppColor.lovolTan)

            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Edit Questions")
                       .foregroundColor(AppColor.lovolTan)
               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    func fillQuestions(){
        tempQuestions = ownQuestions
        tempLeftAnswers = leftAnswers
        tempRightAnswers = rightAnswers
        tempAnswers = answers
    }
    func done(){
        self.answers = tempAnswers
        self.ownQuestions = tempQuestions
        self.rightAnswers = tempRightAnswers
        self.leftAnswers = tempLeftAnswers
    }
    func fillButton(chosenNum : Int, index: Int){
        tempAnswers[index] = chosenNum+1
        
    }
}

struct EditQuestions_Previews: PreviewProvider {
    @State static var ownQuestions : [String] = ["asfasdfsdafsadfsadfsadfsadfasdfasfasdfsdafsadfsadfsadfsadfasdf","2","3"]
    @State static var leftAnswers : [String] = ["asfasdfsdafsadfsadfsadfsadfasdf","2","3"]
    @State static var rightAnswers : [String] = ["asfasdfsdafsadfsadfsadfsadfasdf","2","3"]
    @State static var answers : [Int] = [1,2,3]

    static var previews: some View {
        EditQuestions(ownQuestions:$ownQuestions, leftAnswers: $leftAnswers, rightAnswers: $rightAnswers,answers:$answers)
    }
}
