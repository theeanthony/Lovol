//
//  RequestPeekView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/23/23.
//

import SwiftUI

struct RequestPeekView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject private var requestViewModel : RequestViewModel
    @Binding var editableRequests : [RequestModelPicture]
    
    
    @Binding  var index : Int 
    
    @State private var showError : Bool = false
    @State private var fullError : Bool = false


    var body: some View {
        GeometryReader{ geo in
            VStack{
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                    .padding(.leading,10)

                    Spacer()
                }
                Spacer()
                if !editableRequests.isEmpty{
                    Image(uiImage: editableRequests[index].pic)
                        .resizable()
                        .centerCropped()
                        .frame(width: geo.size.width * 0.5, height: geo.size.width * 0.5)
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(.black,lineWidth:2)
                        )
                    Text(editableRequests[index ].request.nameOfSender).font(.custom("Rubik Regular", size: 22)).foregroundColor(.white)
                        .padding()
                    Text(editableRequests[index ].request.sendRole).font(.custom("Rubik Regular", size: 18)).foregroundColor(.white)
                }
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        cancelRequest()
                    } label: {
                        Image(systemName: "person.fill.xmark")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button {
                        acceptRequest()
                    } label: {
                        Image(systemName: "person.fill.checkmark")
                            .foregroundColor(.white)
                        
                        
                    }
                    Spacer()
                }
                .padding(.bottom,50)
                HStack{
                    Spacer()
                    Button {
                        moveLeft()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Button {
                        moveRight()
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                        
                        
                    }
                    Spacer()
                }
         

                Spacer()
            }
            .frame(width:geo.size.width , height: geo.size.height)
            .background(AppColor.lovolDarkPurple)
        }
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
    private func moveLeft(){
        var newIndex = index - 1
        if newIndex < 0 {
            newIndex = editableRequests.count - 1
        }
        self.index = newIndex
        
    }
    private func moveRight(){
        self.index = (index + 1) % editableRequests.count

    }
}

struct RequestPeekView_Previews: PreviewProvider {
    
    @State static var editableRequests : [RequestModelPicture] = []
    @State static var index : Int = 0
    static var previews: some View {
        RequestPeekView(editableRequests: $editableRequests, index: $index)
    }
}
