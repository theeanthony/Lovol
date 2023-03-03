//
//  QueueSheetView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/8/23.
//

import SwiftUI

struct QueueSheetView: View {
    var queue : [MatchModel]
    
//
    var body: some View {
        GeometryReader{ geo in
            VStack(spacing: 20){
                if !queue.isEmpty{
                    Button {
                        
                    } label: {
                        NavigationLink(destination: ChatView(match: queue[0],groupConvo:false)){
                            MatchMainQueueView(model: queue[0]).frame(width:geo.size.height * 0.5,height:geo.size.height * 0.5)
                        }
                    }

              
                    
//                    Text("Next")
                    
                    if queue.count > 1 {
                        VStack{
                            
                            Rectangle().frame(width:geo.size.width, height: 3).background(AppColor.lovolDarkPurple).opacity(0.8).padding(.top,10)
                            HStack{
                                Text("Next")
                                Spacer()
                            }
                            MatchSecQueueView(model: queue[1])
                                .frame(width:geo.size.height * 0.2,height:geo.size.height * 0.2)
                            HStack{
                                Spacer()
                                Text("\(queue.count - 2) remaining...")
                            }
                        }
                        .frame(width:geo.size.width * 0.85)
                        .font(.custom("Rubik Regular", size: 14))
                        .foregroundColor(AppColor.lovolDarkPurple)
                    }
                    else{
                        Text("\(queue.count - 1) remaining...")
                            .frame(width:geo.size.width * 0.85 , height: geo.size.height * 0.1)
                            .font(.custom("Rubik Regular", size: 14))
                            .foregroundColor(AppColor.lovolDarkPurple)
                            
                    }
                    
                    
                }
                else{
                    Text("No Connections")
                        .font(.custom("Rubik Bold", size: 14))
                        .foregroundColor(AppColor.lovolDarkPurple)
                        .padding(.leading,10)
                    
                    
                }
                   

            }
    
            
            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)
            .frame(width: .infinity, height:.infinity)
            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan))
            .ignoresSafeArea()
        }
    }
}

struct QueueSheetView_Previews: PreviewProvider {
    static var previews: some View {
        QueueSheetView(queue: [])
    }
}
