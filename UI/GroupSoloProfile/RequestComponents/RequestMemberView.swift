//
//  RequestMemberView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/16/23.
//

import SwiftUI

struct RequestMemberView: View {
    @EnvironmentObject private var requestViewModel : RequestViewModel
    @Binding var editableRequests : [RequestModelPicture]
    
    
    @State private var index : Int = 0
    
    @State private var showError : Bool = false
    @State private var fullError : Bool = false
    
    @State private var isPresented : Bool = false
    
    var body: some View {
        GeometryReader{ geo in
            HStack{
//                Button {
//                   moveLeft()
//                } label: {
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.white)
//
//
//                }

                        if !editableRequests.isEmpty{
                            
                            VStack{
                                ForEach(editableRequests.indices, id: \.self){
                                    member in

                                        HStack{
                                            Image(uiImage: editableRequests[member].pic)
                                                .resizable()
                                                .centerCropped()
                                                .frame(width: geo.size.width * 0.175, height: geo.size.width * 0.175)
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                            VStack{
                                                HStack{
                                                    Text(editableRequests[member].request.nameOfSender).font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
                                                Spacer()
                                                }
                                                HStack{
                                                    Text(editableRequests[member].request.sendRole).font(.custom("Rubik Regular", size: 10)).foregroundColor(.white).opacity(0.7)
                                                Spacer()
                                                }
                                                
                                            }
                                            Spacer()                                            
                                            Button {
                                                cancelRequest()
                                            } label: {
                                                Image(systemName: "person.fill.xmark")
                                                    .foregroundColor(.white)
                                            }
                                            .padding(.horizontal)
                                            Button {
                                                acceptRequest()
                                            } label: {
                                                Image(systemName: "person.fill.checkmark")
                                                    .foregroundColor(.white)
                                                
                                                
                                            }
                                            
                                            
                                            
                                        }
                                    
                                }
                            }
                            
                            
                            
           
                            
                            
                            
                            
                            
                        }
       
                        
                        
           
//                    .background(RoundedRectangle(cornerRadius: 10).fill(AppColor.lovolDarkerPurpleBackground))
            

       
//                Button {
//                    moveRight()
//
//                } label: {
//                    Image(systemName: "chevron.right")
//                        .foregroundColor(.white)
//                    
//                    
//                }
            }
        }
                    .alert("Your Team is Full. You Cannot Accept the Request", isPresented: $fullError, actions: {
                        Button("OK", role: .cancel, action: {
        
                        })
                    })
                    .alert("There has been an error accepting the request", isPresented: $showError, actions: {
                        Button("OK", role: .cancel, action: {
        
                        })
                    })
//        .onAppear(perform: onAppear)

//            .frame(width:geo.size.width * 0.9)
    }
    private func moveLeft(){
        var newIndex = index - 1
        print(newIndex)
        if newIndex < 0 {
            newIndex = editableRequests.count - 1
            print(newIndex)
        }
        self.index = newIndex
    }
    private func moveRight(){
        self.index = (index + 1) % editableRequests.count

    }
    private func cancelRequest(){
        requestViewModel.cancelRequest(id: editableRequests[index].request.sendingRequestId) {
            editableRequests.remove(at: index)
        }
    }
    private func acceptRequest(){
//        requestViewModel.acceptRequest(sendRole: editableRequests[index].request.sendRole, sendName: editableRequests[index].request.nameOfSender, sendId: editableRequests[index].request.sendingRequestId, groupId: editableRequests[index].request.groupId) { result in
//            switch result{
//            case .success(true):
//                editableRequests.remove(at: index)
//            case .success(false):
//                showError = true
//            case .failure(let error):
//                print("error accepting request \(error)")
//                showError = true
//            }
//        }
    }
//    private func onAppear(){
//        self.requests = editableRequests
//    }
}

//struct RequestMemberView_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestMemberView(name:"Anthony")
//    }
//}
