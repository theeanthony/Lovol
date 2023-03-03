//
//  LeaderBoardFrame.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/29/23.
//

import SwiftUI

struct LeaderBoardFrame: View {
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
    @EnvironmentObject private var profilesViewModel : ProfilesViewModel
    @State private var leaderModels : [BoardModel] = []
//    @State private var topThreeLeaders : [LeaderBoardModel] = []
    @State private var loading : Bool = true
    let groupId: String
    var body: some View {
        
        GeometryReader{geo in
            VStack{
            ScrollView{
                
                LeaderBoardTopThree()
                    .frame(width:geo.size.width,height:geo.size.height * 0.3)
                
                Section(header: ListHeader(text: "Others")){
                    
                    if loading{
                        ProgressView()
                    }else{
                        ForEach(leaderModels.indices,id:\.self){
                            index in
                            
                            HStack{
                                Text("#\(leaderModels[index].ranking)")
                                Text(leaderModels[index].teamName)
                                Spacer()
                                Text("\(leaderModels[index].teamPoints)")
                            }
                            .frame(width:geo.size.width * 0.7)
                            .padding(15)
                            .font(.custom("Rubik Bold", size: 12)).foregroundColor(.white)
                            
                            .background(RoundedRectangle(cornerRadius:30).fill(groupId == leaderModels[index].id ? AppColor.lovolPinkish : AppColor.lovolDarkerPurpleBackground))
                            
                            
                            
                        }
                        .padding(10)
                    }
                    
                }
                .frame(width:geo.size.width * 0.95)
                Spacer()
            }
            .frame(height:geo.size.height * 0.9)
        }
        }
        .onAppear(perform:onAppear)
        .background(BackgroundView())

        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
        
    }
    private func onAppear(){
        
        profilesViewModel.fetchLeaderBoard(groupId: groupId) { result in
            switch result {
            case .success(let fetchedLeaders):
                self.leaderModels = fetchedLeaders
                self.leaderModels.sort{
                    $0.ranking < $1.ranking
                }
                loading = false
            case .failure(let error):
                print("error fetching rest of leaderboard \(error)")
                
            }
        }
        
    }
}

struct LeaderBoardFrame_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardFrame( groupId: "")
    }
}
