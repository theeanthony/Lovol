//
//  RequestPersonView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/19/22.
//

import SwiftUI

struct RequestPersonView: View {
    
    @EnvironmentObject private var requestViewModel : RequestViewModel
    
    var request : RequestModel
    var groupId : String
    
    @State private var showError : Bool = false
    @State private var showFullError : Bool = false
    
    @Binding var requests : [RequestModel]
    var index : Int
    
    var body: some View {
        VStack(spacing: 0){
            HStack{
             
                    Spacer()
                    Text(request.nameOfSender)
                    Spacer()
                    Button {
                        reject()
                    } label: {
                           Image(systemName: "xmark")
                            .foregroundColor(.red)
                    }
                Spacer()
                    Button {
                accept()
                    } label: {
                       
                            Image(systemName: "checkmark")
                            .foregroundColor(.green)


                    }
                Spacer()

            }
            .frame(width:300,height:50)
            .foregroundColor(AppColor.lovolTan)
            HStack(spacing:0){
                Button {
                    
                } label: {
                    NavigationLink(destination: RequestCheckProfileView(senderId: request.sendingRequestId)) {
                        RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolLightPurple).frame(width:300, height:30)
                            .overlay(Image(systemName:"arrow.right").foregroundColor((AppColor.lovolTan)))
                    }
                  
                }



                
                
            }
        }
        .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolPrettyPurple))

        .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolTan)
        .alert("Error accepting request. Please try again", isPresented: $showError, actions: {
            Button("OK", role: .cancel, action: {
                
            })
        })
        .alert("Error accepting request. User may not exist, or group is full.", isPresented: $showFullError, actions: {
            Button("OK", role: .cancel, action: {
                
            })
        })
//        .frame(width: 300, height: 60)

    }
    private func accept(){
        
//        requestViewModel.acceptRequest(sendRole: request.sendRole, sendName: request.nameOfSender, sendId: request.sendingRequestId, groupId: groupId) { result in
//            switch result{
//            case .success(true):
//                requests.remove(at: index)
//            case .success(false):
//                showFullError = true
//            case .failure(let error):
//                print("error accepting request \(error)")
//                showError = true
//                
//            }
//        }
        
    }
    private func reject(){
        requestViewModel.cancelRequest(id: request.sendingRequestId) {
            requests.remove(at: index)
        }
        
    }
}

struct RequestPersonView_Previews: PreviewProvider {

    static let request : RequestModel = RequestModel(id: "0", sendingRequestId: "1", nameOfSender: "Anthony", groupId: "1", sendRole: "", isATeam: false)
    @State static var requests: [RequestModel] = []
    static var previews: some View {
        RequestPersonView(request:request, groupId: "", requests: $requests, index: 1)
    }
}
