//
//  RoleView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import SwiftUI

struct RoleView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(.white)
                  
              }
          }
      }
//    let email : String

    let name : String
    let age: Bool 
    @State private var charLimit : Int = 24
    @State private var role : String = ""
    @State private var roleSheet : Bool = false
    var body: some View {
        NavigationStack{
            GeometryReader { geo in
                    VStack{
                        Text("Enter Your Pseudo Role").font(.custom("Rubik Bold", size: 24)).foregroundColor(.white)
//                        HStack{
                        HStack{
   
                            TextField("", text: $role, axis:.horizontal)
//                                .fixedSize()
                                .placeholder(when: role.isEmpty) {
                                Text("What do you do").opacity(0.5).font(.custom("Rubik Regular", size: 28)).foregroundColor(.white)
                            }.onChange(of: role, perform: {newValue in
                                if(newValue.count >= charLimit){
                                    role = String(newValue.prefix(charLimit))
                                }
                            })
                            //                            Text("\(charLimit - name.count)").foregroundColor(.white).font(.headline).bold()
                            //                                .padding(.trailing,5)
                            
                            //                        }
                        }
                        .padding(.bottom,40)
                        Button {
                            
                        } label: {
                            NavigationLink(destination: PictureView(name:name, role:role, age: age)) {
                                Text("Next")
                                    .font(.custom("Rubik Bold", size: 22)).foregroundColor(.white)

                                    .padding()
                                    .frame(width:geo.size.width * 0.7)
                                    .background(RoundedRectangle(cornerRadius: 30).fill( role.count > 0 ? AppColor.lovolPinkish : AppColor.lovolPinkish.opacity(0.5)))
                            }
                     
                        }
                        .disabled(role.count == 0 )

                    }
                    .font(.custom("Rubik Regular", size: 28)).foregroundColor(.white)
                    .frame(width:geo.size.width * 0.9)
                    .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

                
                
            }
            .ignoresSafeArea(.keyboard)
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(AppColor.lovolDark)

            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   HStack{
                       Spacer()
                       Button {
                         roleSheet = true 
                       } label: {
                           Image(systemName: "questionmark.circle.fill").foregroundColor(.white)
                       }
                   }


               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $roleSheet) {
                RoleSheet()
                    .presentationDetents([ .medium])
                        .presentationDragIndicator(.hidden)
                

            }
//            .onAppear(perform:onAppear)
        }
    }
}

//struct RoleView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoleView(name: "Ant", age: false)
//    }
//}
