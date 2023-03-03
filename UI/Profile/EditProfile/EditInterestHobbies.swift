//
//  EditInterestHobbies.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/7/22.
//

import SwiftUI

struct EditInterestHobbies: View {
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
    @State var jsonInterestHolder : [InterestsModel] = []
    @State var showWarning : Bool = false
    @State var showNeedMoreInterests : Bool = false
    @Binding var interests : [String]
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
                done()
            }, label: {
                Text("done")
               
                    
                  
            })
            .disabled(checkForMinimumInterests())
            .padding(.top, 30)

            


    }
                .onAppear(perform: performOnAppear)
        .padding(.top, 10)

        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
        )
        .navigationBarTitle("")
        .toolbar {

                    ToolbarItemGroup(placement: .principal) {
                        Text("Edit Interest/Hobbies")
                            .foregroundColor(AppColor.lovolTan)
                    }
    
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
            }
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
    private func checkForMinimumInterests() -> Bool{
        if interests.count < 3 || interests.count > 6 {
            showWarning = false
            return true
        }
//        showWarning = true
        return false


        }
    private func done(){
        
        presentationMode.wrappedValue.dismiss()
    }
    }
                                       

struct EditInterestHobbies_Previews: PreviewProvider {
    @State static var interests : [String] = []
    static var previews: some View {
        EditInterestHobbies(interests:$interests)
    }
}
