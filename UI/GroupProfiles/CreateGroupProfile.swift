//
//  CreateGroupProfile.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/24/22.
//

import SwiftUI
import UniformTypeIdentifiers

struct CreateGroupProfile: View {
    
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

    private let charLimit: Int = 15
    @State var name : String = ""
    @State var showWarning : Bool = false
    @State var isLoading : Bool = false
    @State var bio : String = ""
    

    var body: some View {
        NavigationStack{
            VStack{

//                ZStack{
//                    RoundedRectangle(cornerRadius: 50)
//                        .fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8)))
//                        .frame(width: 325, height: 55)
//                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
//                    HStack{
//                        TextField("", text: $name).placeholder(when: name.isEmpty) {
//                            Text("Squad Name")
//                        }.onChange(of: name, perform: {newValue in
//                            if(newValue.count >= charLimit){
//                                name = String(newValue.prefix(charLimit))
//                            }
//                        })
//                        Text("\(charLimit - name.count)").foregroundColor(AppColor.lovolDarkPurple).font(.headline).bold()
//                            .padding(.trailing,5)
//                    }
//                    .font(.custom("Rubik Regular", size: 24)).foregroundColor(AppColor.lovolDarkPurple)
//                    .padding(.leading,10)
//                    .textInputAutocapitalization(.never)
//                    .disableAutocorrection(true)
//                    .frame(width: 325, height: 55)
//                }
//                .padding(.vertical,20)
                VStack{
                    Text("Create team Instantly")
                        .font(.custom("Rubik Regular", size: 24)).foregroundColor(AppColor.lovolTan)
                        .padding(.bottom,5)
                    Text("Your profile information will be used to fill in the required info to make a group, excluding your name. You can edit the information later.")
                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                }
                .frame(alignment: .center)
                .padding(.horizontal, 30)
                VStack{
                    Button {
                        
                    } label: {
                        NavigationLink(destination: CreateGroupNameView(), label: {
                            Image(systemName: "checkmark")
                                .resizable()
                                .frame(width:20,height:30)
                                .padding(11)
                                .background(Circle().fill(AppColor.lovolDarkPurple))
                                .foregroundColor(AppColor.lovolTan)
                        })
                     
                        
                    }
                    Text("Or")
                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
                        .padding(.vertical,15)
                    
                    Text("Continue Creating Team")
                        .font(.custom("Rubik Regular", size: 24)).foregroundColor(AppColor.lovolTan)
                    Button {
                        
                    } label: {
                        NavigationLink(destination: CreateGroupNameView(), label: {
                            Image(systemName: "arrow.right")
                                .resizable()
                                .frame(width:30,height:25)
                                .padding(9)
                                .background(Circle().fill(AppColor.lovolDarkPurple))
                                .foregroundColor(AppColor.lovolTan)
                            
                        })

                    }

                }
                .padding(.vertical,15)
            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Create Team")
                       .foregroundColor(AppColor.lovolTan)
               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .alert("Please enter a name to continue", isPresented: $showWarning, actions: {
                Button("OK", role: .cancel, action: {
                    
                })
            })
        }
    }
    private func finishProfile(){
        if name.isEmpty{
            showWarning = true
            return
        }
        isLoading = true
        
    }
    private func continueMakingProfile(){
        if name.isEmpty{
            showWarning = true
            return
        }
    }
}
                
                
            


struct CreateGroupProfile_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupProfile()
    }
}
