//
//  BonusRoundView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/10/23.
//

import SwiftUI

struct BonusRoundView: View {
    @State private var isPresented : Bool = false
    
    @State private var details : BonusPeek = BonusPeek(isActive: false, bonusType: "")
    var body: some View {
        GeometryReader{ geo in
            
            HStack{
//                Spacer()
                VStack{
                    HStack{
                        Text("Bonus Event")
                        Spacer()
                        
                    }
                    .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                    
                    .padding(.leading,10)
                    
                    HStack{
                        Text("Category: \(details.bonusType)")
                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)

                        Spacer()
                        
                    }
                    .padding(.leading,10)
                    .padding(.top,5)
                    HStack{
                        Button {
                            
                        } label: {
                            
                            Button {
                                self.isPresented = true
                            } label: {
//                                NavigationLink(destination: HomeView()) {
                                    Text("Start")
                                        .padding(5)
                                        .padding(.horizontal,5)
                                        .background(RoundedRectangle(cornerRadius:30).fill(AppColor.lovolPinkish))
                                        .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)

//                                }

                            }
//                            .fullScreenCover(isPresented: $isPresented) {
//                                HomeView()
//                            }
                    
                        }
                        Spacer()
                    }
                    .padding(.leading,10)
                    
                    
                    
                }
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                .frame(width: geo.size.width)
                .padding(10)
                
                .background(RoundedRectangle(cornerRadius: 5).fill(AppColor.trophyWarmPink))
//                .onAppear(perform: fetchLiveStatus)
//                Spacer()

            }
            
            
        }
    }
    
}

struct BonusRoundView_Previews: PreviewProvider {
    static var previews: some View {
        BonusRoundView()
    }
}
