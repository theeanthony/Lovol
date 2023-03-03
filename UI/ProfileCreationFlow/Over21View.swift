//
//  NameView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import SwiftUI

struct Over21View: View {



    
    @State private var ageSheet : Bool = false
    
    @State private var age : Bool = false
    
    @State private var initial : Bool = false
//    let email : String


    var body: some View {
        NavigationStack{
            GeometryReader { geo in
                    VStack{
                        Text("Are you 21 or older?").font(.custom("Rubik Bold", size: 24)).foregroundColor(.white)
                        
                        
                        HStack{
                            Spacer()
                            Button {
                                self.initial = true
                                self.age = true
                            } label: {
                                Text("Yes")
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius:30).fill( age && initial ? AppColor.lovolPinkish : .clear))
                            }
                            Spacer()
                            Button {
                                self.initial = true

                                self.age = false

                            } label: {
                                Text("No")
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius:30).fill( !age && initial ? AppColor.lovolPinkish : .clear))
                            }
                            Spacer()

                        }
                        .padding(.vertical)
                        .padding(.vertical)
                        .padding(.vertical)
                        .padding(.vertical)



                        Button {
                            
                        } label: {
                            NavigationLink(destination: NameView(age:age)) {
                                Text("Next")
                                    .font(.custom("Rubik Bold", size: 22)).foregroundColor(.white)

                                    .padding()
                                    .frame(width:geo.size.width * 0.7)
                                    .background(RoundedRectangle(cornerRadius: 30).fill(  !initial ? AppColor.lovolPinkish.opacity(0.5) : AppColor.lovolPinkish ))
                            }
                     
                        }
                        .disabled(!initial)

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
                           ageSheet = true
                       } label: {
                           Image(systemName: "questionmark.circle.fill").foregroundColor(.white)
                       }
                   }


               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $ageSheet) {
                Over21Sheet()
                    .presentationDetents([ .medium])
                        .presentationDragIndicator(.hidden)
                

            }
//            .onAppear(perform:onAppear)
        }
    }
 

   
}

struct Over21View_Previews: PreviewProvider {
    static var previews: some View {
        Over21View()
    }
}
