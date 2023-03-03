//
//  CreateGroupCollegeView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/8/22.
//

import SwiftUI

struct CreateGroupCollegeView: View {
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
    
    @State var college : String
    @State var occupation : String = ""
    @State var searchString = ""
   
    @State var collegeModel : [CollegeModel] = []
    @State var askAlum : Bool = false
     
    
    var collegeList : [String] {
        var college : [String] = []
        for index in collegeModel {
            college.append(index.institution)
        }
        return college
    }
    var searchResults: [String] {
        
        if searchString.count == 0 {
            return ["none"]
        }

        return collegeList.filter {$0.lowercased().contains(searchString.lowercased())}


    }
    var body: some View {
        NavigationStack{
            GeometryReader{geo in
                VStack{
                    
                    Text("Choose Current or Former University to Represent")
                        .foregroundColor(AppColor.lovolTan)
                        .font(.custom("Rubik Regular", size: 16))
                    
                    SearchBar(text: $searchString)
                        .padding(.horizontal,10)
                        .font(.custom("Rubik Regular", size: 16))
                        .foregroundColor(AppColor.lovolDarkPurple)
                        .frame(width:geo.size.width * 0.9, height:geo.size.height * 0.1)

                    
                    //                     List{
                    if !searchString.isEmpty{
                        ScrollView{
                            ForEach(searchResults, id: \.self) { item in
                                Button {
                                    storeCollege(college: item)
                                } label: {
                                    VStack{
                                        Text(item)
                                            .font(.custom("Rubik Regular", size: 14))
                                            .padding(.vertical,5)
                                        if item != searchResults[searchResults.count-1]{
                                            Rectangle()
                                                .frame(width:geo.size.width * 0.7, height:4)
                                        }
                                       
                                    }
                                }
                                
                            }
                            
                            .foregroundColor(AppColor.lovolDarkPurple)
                        }
                        //
                        
                        .frame(width:geo.size.width * 0.8, height: 50)
                        .background(AppColor.lovolTan)
                        .cornerRadius(20)
                        .padding(.top,10)
                    }
                    
                    HStack{
                        Image(systemName: "graduationcap")
                        Text(college)
                            .foregroundColor(AppColor.lovolDarkPurple)
                            .padding(.vertical,10)
                            .font(.custom("Rubik Regular", size: 14))
                    }
                    .frame(width:geo.size.width * 0.8, height:50)
                    .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolTan))
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolDarkPurple)
                    .padding(.bottom,15)
                    .padding(.top,15)
                    
//                    if askAlum {
//                        VStack{
//                            Text("Are you an Alumni?")
//                            HStack{
//
//                                Button {
//                                    answerNo()
//                                } label: {
//                                    Text("No")
//                                }
//                                .padding(.trailing,15)
//                                Button {
//                                    answerYes()
//                                } label: {
//                                    Text("Yes")
//                                }
//                                .padding(.leading,15)
//
//
//
//                            }
//                            .padding(.top,15)
//                        }
//                        .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)
//
//
//                    }
                    
                    
                    Button(action:{
                    }, label: {
                        NavigationLink(destination: CreateGroupOccupationView(name: name, bio: bio, college: college, occupation: occupation)) {
                            
                            Image(systemName:"arrow.right")
                                .centerCropped()
                                .frame(width: 50, height: 40)
                                .foregroundColor(AppColor.lovolTan)
                            
                        }
                    })
                    .padding(.top,40)
                    
                    
                }
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            }
                .frame(maxWidth:.infinity,maxHeight:.infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
                )
                .navigationBarTitle("")
                .toolbar {
                   ToolbarItemGroup(placement: .principal) {
                       Text("Choose College")
                           .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

                   }
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: btnBack)
                .navigationBarTitleDisplayMode(.inline)
            
        }
        .onAppear(perform: loadColleges)

    }
                                      

    private func storeCollege(college: String){


        self.college = college
        askAlum = true
        searchString = ""


    }
    private func loadColleges(){

        collegeModel = loadCollegeJson()

    }
    private func answerNo(){
   askAlum = false
   
}
    private func answerYes(){
   college += " Alumnus"
        askAlum = false
}
    
}

struct CreateGroupCollegeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupCollegeView(name: "name", bio: "bio", college: "Santa Clara University")
    }
}
