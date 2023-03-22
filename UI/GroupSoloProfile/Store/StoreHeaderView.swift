//
//  StoreHeaderView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/18/23.
//

import SwiftUI

struct StoreHeaderView: View {
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    let groupId : String
    @Binding var tokens : Tokens 
    
    @Binding var cantPurchaseLovols : Bool
    
    var body: some View {
        
        GeometryReader{geo in
            
            VStack{
                
                HStack{
                    Spacer()
                    Circle()
                        .fill(AppColor.strongRed)
                        .frame(width:geo.size.width * 0.15,height:geo.size.width * 0.15)
                        .overlay(
                            VStack{
                                Text("2x")
                                    .font(.custom("Rubik Bold", size: 24)).foregroundColor(.white)

                            })
                    Text("\(tokens.multiplier)")
                        .font(.custom("Rubik Bold", size: 32)).foregroundColor(.white)
 
                    Spacer()
                    Image("resurrection")
                        .resizable()
                        .frame(width:geo.size.width * 0.2,height:geo.size.width * 0.2)
                    Text("\(tokens.resurrection)")
                        .font(.custom("Rubik Bold", size: 32)).foregroundColor(.white)

                    Spacer()
                    
                }
                HStack{
                    Spacer()
                    lovolBit(height: geo.size.height * 0.2, width: geo.size.width * 0.08)
                    Text("\(tokens.lovolBits)")
                        .font(.custom("Rubik Bold", size: 32)).foregroundColor(.white)

                    Spacer()
                    Image("logo")
                        .resizable()

                        .frame(width:geo.size.width * 0.2,height:geo.size.width * 0.2)
                    Text("\(tokens.lovols)")
                        .font(.custom("Rubik Bold", size: 32)).foregroundColor(.white)

                    Spacer()
                }
            }
            
        }
        .onAppear(perform: fetchTokens)
    }
    private func fetchTokens(){
        
        profileViewModel.fetchTeam(id: groupId) { result in
            switch result {
            case .success(let team):
                
                let newTokens : Tokens = Tokens(lovols: team.teamLovols, multiplier: team.multiplier, resurrection: team.resurrection, lovolBits: team.teamPoints)
                self.tokens = newTokens
                return
            case .failure(let error):
                print("Error fetching team for points \(error)")
                return
            }
        }
        
        
        
    }
}

//struct StoreHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        StoreHeaderView(groupId:"")
//    }
//}

struct Tokens {
    
    var lovols : Int
    var multiplier : Int
    var resurrection: Int
    var lovolBits : Int
    
    init(){
        self.lovols = 0
        self.multiplier = 0
        self.resurrection = 0
        self.lovolBits = 0
    }
    init(lovols:Int,multiplier:Int,resurrection:Int,lovolBits:Int){
        self.lovols = lovols
        self.multiplier = multiplier
        self.resurrection = resurrection
        self.lovolBits = lovolBits
    }
    
}
