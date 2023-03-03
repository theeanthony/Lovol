//
//  TeamMemberView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/15/23.
//

import SwiftUI

struct TeamMemberView: View {
    let member : MemberModel
    var body: some View {
        GeometryReader{ geo in
            VStack{
                ZStack{
                    Image(uiImage: member.pic)
                        .resizable()
                        .centerCropped()
                        .frame(width:geo.size.width * 1.15, height: geo.size.width * 1.15)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(.black,lineWidth:2)
                        )
                    
                        .background(Rectangle().fill(AppColor.lovolPinkish).frame(width:geo.size.width * 1.425, height:geo.size.width * 1.5).cornerRadius(20, corners: [.topLeft]))
                    
                    
                    
                }
//                .padding(8)
                Rectangle().fill(AppColor.lovolNamePink)
                    .frame(width:geo.size.width * 1.425, height:geo.size.width * 0.65)
                    .cornerRadius(20, corners: [ .bottomRight])
                    .overlay(
                        VStack{
                            Text(member.name)
                                .font(.custom("Rubik Regular", size: 10))
                            Text(member.role)
                                .font(.custom("Rubik Regular", size: 8)).foregroundColor(AppColor.lovolLightGray)
                        }
                        
                        
                    )
                
            }
        }
    }
}

//struct TeamMemberView_Previews: PreviewProvider {
//    @State static var requestSent : Bool = false
//    @State static var duplicateRequest : Bool = false
//
//    static var previews: some View {
//        TeamMemberView(member: MemberModel(name: "Anthony", role: "Im super cute", pic: UIImage(named:"elon_musk")!))
//    }
//}
struct EmptyMemberView: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @EnvironmentObject private var requestViewModel : RequestViewModel
    let groupId : String
    
    @Binding var requestSent : Bool
    @Binding var duplicateRequest : Bool
    let teamName : String
    @Binding var waitingTeamName : String
    @State private var errorSendingRequest : Bool = false 
    
    var body: some View {
        GeometryReader{ geo in
            
            Button {
                sendRequest()
                
            } label: {
                VStack{
                    
                    ZStack{
                        
                        
                        
                        Circle()
                            .fill(.clear)
//                            .frame(width:geo.size.width * 0.15, height: geo.size.width * 0.15)
                            .frame(width:geo.size.width * 1.15, height: geo.size.width * 1.15)
                            .aspectRatio(contentMode: .fill)
                        
                        
                            .background(Rectangle().fill(AppColor.lovolPinkish)
                                
//                                .frame(width:geo.size.width * 0.225, height:geo.size.width * 0.225)
                                .frame(width:geo.size.width * 1.425, height:geo.size.width * 1.5)
                                
                                .cornerRadius(20, corners: [.topLeft, ]))
                            .overlay(
                                Text("Join Team").font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                            )
                        
                        
                        
                    }
                    Rectangle().fill(AppColor.lovolNamePink)
                    
//                        .frame(width:geo.size.width * 0.225, height:geo.size.width * 0.1)
                        .frame(width:geo.size.width * 1.425, height:geo.size.width * 0.65)
                        .cornerRadius(20, corners: [ .bottomRight])
                    
                    
                }
            }
//            .alert("Request Sent", isPresented: $requestSent, actions: {
//                Button("OK", role: .cancel, action: {
//     
//                })
//            })
        }


    }
    private func sendRequest(){
        requestViewModel.sendRequest(groupId: groupId) { result in
            switch result {
            case .success(true):
                self.requestSent = true
                self.waitingTeamName = teamName
//                presentationMode.wrappedValue.dismiss()
            case .success(false):
                duplicateRequest = true 
            case .failure(let error):
                print("error sending request \(error)")
                
            }
        }
    }
}
