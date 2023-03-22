//
//  GameShowLabelView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/5/23.
//

import SwiftUI
import AVKit

struct GameShowLabelView: View {
    
    @EnvironmentObject private var eventViewModel : EventViewModel
    
    @State private var liveEventInfo : LiveEventModel = LiveEventModel(startTime: Date(), isActive: false, videoURL: "", seconds: 0, beginingTime: Date(), prize: "", season: "", isSelection:true)
    
    @State private var showGameShow : Bool = false
    @State private var isPresented : Bool = false 
    var body: some View {
        GeometryReader{ geo in
            
            HStack{
//                Spacer()
                VStack{
                    HStack{
                        Text(liveEventInfo.isSelection ? "Gameshow Selection Starts" : "Gameshow Starts")
                        Spacer()
                        
                    }
                    .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                    
                    .padding(.leading,10)
                    
                    HStack{
                        Text("\(liveEventInfo.startTime.shortTime) \(liveEventInfo.startTime.fullDate)")
                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)

                        Spacer()
                        
                    }
                    .padding(.leading,10)
                    .padding(.top,5)
                    HStack{
                        Button {
                            
                        } label: {
                            
                            Button {
                                
                                if showGameShow{
                                    self.isPresented = true

                                }
                            } label: {
//                                NavigationLink(destination: HomeView()) {
                                    Text("Let's go")
                                        .padding(5)
                                        .padding(.horizontal,5)
                                        .background(RoundedRectangle(cornerRadius:30).fill(AppColor.lovolTan))
                                        .font(.custom("Rubik Bold", size: 14)).foregroundColor(.black)

//                                }

                            }
                            .sheet(isPresented: $isPresented) {
                                ExampleVideoView(player: AVPlayer(url: URL(string: liveEventInfo.videoURL!)!))
                                
                                    .presentationDetents([.large])

                            }
                    
                        }
                        Spacer()
                    }
                    .padding(.leading,10)
                    
                    
                    
                }
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                .frame(width: geo.size.width)
                .padding(10)
                
                .background(RoundedRectangle(cornerRadius: 5).fill(AppColor.lovolTeal))
                .onAppear(perform: fetchLiveStatus)
//                Spacer()

            }
            
            
        }
    }
    
    func fetchLiveStatus(){
        eventViewModel.checkLiveStatus { result in
            switch result {
                
            case .success(let live):
                self.liveEventInfo = live
                self.showGameShow = true
                
            case .failure(_):
                
                showGameShow = false
                
            }
        }
    }
    
}

struct GameShowLabelView_Previews: PreviewProvider {
    static var previews: some View {
        GameShowLabelView()
    }
}
