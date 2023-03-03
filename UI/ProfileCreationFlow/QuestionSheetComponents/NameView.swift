//
//  NameView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import SwiftUI

struct NameView: View {
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
    
    @State private var name : String = ""
    @State private var charLimit : Int = 12
//    let email : String
    let age : Bool
    
    
    @State private var nameSheet : Bool = false
    
    weak var textField: UITextField!

    var body: some View {
        NavigationStack{
            GeometryReader { geo in
                    VStack{
                        Text("Enter Your Nickname").font(.custom("Rubik Bold", size: 24)).foregroundColor(.white)
//                        HStack{
                        HStack{
                            
                            TextField("", text: $name, axis:.horizontal)
//                                .fixedSize(horizontal: true, vertical: false)
                                .placeholder(when: name.isEmpty) {
                                Text("Nickname").opacity(0.5).font(.custom("Rubik Regular", size: 28)).foregroundColor(.white)
                            }.onChange(of: name, perform: {newValue in
                                if(newValue.count >= charLimit){
                                    name = String(newValue.prefix(charLimit))
                                }
                            })
                            
                            //                            Text("\(charLimit - name.count)").foregroundColor(.white).font(.headline).bold()
                            //                                .padding(.trailing,5)
                            
                            //                        }
                        }
                        
                        .padding(.bottom,40)
                        Button {
                            
                        } label: {
                            NavigationLink(destination: RoleView(name:name, age: age)) {
                                Text("Next")
                                    .padding()
                                    .font(.custom("Rubik Bold", size: 22)).foregroundColor(.white)

                                    .frame(width:geo.size.width * 0.7)
                                    .background(RoundedRectangle(cornerRadius: 30).fill( name.count > 0 ? AppColor.lovolPinkish : AppColor.lovolPinkish.opacity(0.5)))
                            }
                     
                        }
                        .disabled(name.count == 0 )

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
               ToolbarItemGroup(placement: .navigationBarTrailing) {
                   HStack{
                       Button {
                           nameSheet = true 
                       } label: {
                           Image(systemName: "questionmark.circle.fill").foregroundColor(.white)
                       }
                   }


               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $nameSheet) {
                NameSheet()
                    .presentationDetents([ .medium])
                        .presentationDragIndicator(.hidden)
                

            }
//            .onAppear(perform:onAppear)
        }
    }
 

   
}

struct NameView_Previews: PreviewProvider {
    static var previews: some View {
        NameView(age: false)
    }
}
