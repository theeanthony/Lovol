//
//  EditCollege.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/7/22.
//

import SwiftUI
 
struct EditCollege: View {
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
    @State var tempCollege : String = ""
    @Binding var college : String
    @State var searchString = ""
    @State var collegeModel : [CollegeModel] = []
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
    @State var askAlum : Bool = false
    var body: some View {
        NavigationStack{
            VStack{
                VStack{
                    VStack(spacing:0){
                        HStack{
                            Text("College")
                                .foregroundColor(AppColor.lovolDarkPurple)
                                .font(.custom("Rubik Regular", size: 14))
                            
                            Spacer()
                        }
                        .frame(width:280)
                        SearchBar(text: $searchString)
                            .padding(.horizontal,10)
                            .font(.custom("Rubik Regular", size: 20))
                            .foregroundColor(AppColor.lovolTan)
                            .frame(width:320)
                    }
                    .padding(.vertical,5)
                    if !searchString.isEmpty{
                        ScrollView{
                            ForEach(searchResults, id: \.self) { item in
                                Button {
                                    storeCollege(college: item)
                                } label: {
                                    Text(item)
                                        .font(.custom("Rubik Regular", size: 14))
                                        .foregroundColor(AppColor.lovolDarkPurple)
                                    
                                    
                                }
                                
                            }
                            
                        }
                        //
                        
                        .frame(width:280, height:100)
                        .background(AppColor.lovolTan)
                        .cornerRadius(20)
                    }
                    HStack{
                        Image(systemName: "graduationcap")
                        Text(tempCollege)
                            .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolDarkPurple)
                            .padding(.vertical,10)
                    }
                    .frame(width:280)
                    .background(RoundedRectangle(cornerRadius:10).fill(AppColor.lovolTan))
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolDarkPurple)
                    .padding(.bottom,15)
                    .padding(.top,10)
                    
                    if askAlum {
                        VStack{
                            Text("Are you an Alumni?")
                            HStack{
                                
                                Button {
                                    answerNo()
                                } label: {
                                    Text("No")
                                }
                                .padding(.trailing,10)
//                                .padding(.horizonta)
                                Button {
                                    answerYes()
                                } label: {
                                    Text("Yes")
                                }
                                .padding(.leading,10)

                                
                                
                            }
                            .padding(.top,15)
                        }
                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                        
                        
                    }
                    
                    Button {
                        done()
                    } label: {
                        Text("done")
                    }
                    .padding(.top,15)
                    
                }
        
                            



            }
            .onAppear(perform: fillCollege)
            .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)

            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Edit College")
                       .foregroundColor(AppColor.lovolTan)
               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    func fillCollege(){
        tempCollege = college
        collegeModel = loadCollegeJson()

    }
    private func storeCollege(college: String){


        tempCollege = college
        askAlum = true
        searchString = ""


    }

    private func answerNo(){
   askAlum = false
   
}
    private func answerYes(){
   tempCollege += " Alum"
        askAlum = false
}
    private func done(){
        self.college = tempCollege
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditCollege_Previews: PreviewProvider {
    @State static var college : String = "bio"

    static var previews: some View {
        EditCollege(college:$college)
    }
}
