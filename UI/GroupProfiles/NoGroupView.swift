//
//  NoGroupView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/24/22.
//

import SwiftUI

struct NoGroupView: View {

    @State private var groupId : String = ""
    @State private var groupName : String = ""
    @EnvironmentObject var viewModel: FirestoreViewModel
    @EnvironmentObject var requestViewModel : RequestViewModel
    
    @State private var isLoading: Bool = false
    
    @State private var showCannotSendNetworkRequest = false
    @State private var showCannotSendRequest: Bool = false
    @State private var requestSent: Bool = false
    private let charLimit: Int = 10
    
    @State private var pendingRequest : String = ""
    @State private var showCannotCreateGroup : Bool = false


    
    var body: some View {
        VStack{
            ScrollView{
                Text("Not Part Of A Team Yet...")
                    .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolTan)
                
                    .padding()
                    .padding()
                
                HStack{
                    Spacer()
                    
                    TextField("", text: $groupId).placeholder(when: groupId.isEmpty) {
                        Text("Enter Team ID #").foregroundColor(AppColor.lovolEnterNameexDarkPurple)
                        
                    }.onChange(of: groupId, perform: {newValue in
                        if(newValue.count >= charLimit){
                            groupId = String(newValue.prefix(charLimit))
                        }
                        
                        
                    })
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(AppColor.lovolDarkPurple)            .padding(10)
                    
                    Spacer()
                }
                .frame(width:190)
                .font(.custom("Rubik Regular", size: 20))
                
                .background(RoundedRectangle(cornerRadius: 30).fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.8))))
                .padding(.horizontal,20)
                
                
                Button(action: sendInvite, label: {
                    Image(systemName: "paperplane.fill")
                        .centerCropped()
                        .frame(width:40,height:40)
                        .padding(15)
                        .foregroundColor(AppColor.lovolTan)
                        .background(Circle().fill(AppColor.lovolDarkPurple))
                })
                .showLoading(isLoading)
                .padding(.vertical,30)
                VStack{
                    Text("Or")
                        .padding()
                    
                    
                }
                .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolTan)
                
                
                Button(action: sendInvite, label: {
                    NavigationLink(destination: CreateGroupNameView()) {
                        HStack{
                            Text("Create a Team")
                            Image(systemName: "chevron.right")
                        }
                        .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolTan)
                        //                    VStack{
                        //                        Image(systemName: "face.smiling.fill")
                        //                            .centerCropped()
                        //                            .frame(width:20,height:20)
                        //                            .foregroundColor(AppColor.lovolTan)
                        //
                        //
                        //                        HStack{
                        //                            Image(systemName: "face.smiling.fill")
                        //                                .centerCropped()
                        //                                .frame(width:20,height:20)
                        //
                        //                                .foregroundColor(AppColor.lovolTan)
                        //
                        //
                        //                            Image(systemName: "face.smiling.fill")
                        //                                .centerCropped()
                        //                                .frame(width:20,height:20)
                        //                                .foregroundColor(AppColor.lovolTan)
                        //
                        //
                        //
                        //                        }
                        //                    }
                        
                        
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        showErrorCantCreateGroupWithRequestSent()
                    })
                    //                .background(Circle().fill(AppColor.lovolDarkPurple).frame(width: 80,height:80))
                    .padding(.top,10)
                    
                    
                    
                })
                .disabled(requestSent)
                
                
                .showLoading(isLoading)
                .padding(.vertical,30)
                if requestSent{
                    VStack{
                        Text("Waiting For...")
                        HStack{
                            Text("\(groupId)")
                            Button(action: cancelRequest) {
                                Image(systemName: "x.circle.fill")
                                    .foregroundColor(AppColor.lovolTan)
                            }
                        }
                        .padding(.top,5)
                    }
                    .font(.custom("Rubik Regular", size: 18)).foregroundColor(AppColor.lovolTan)
                }
                
                
                
            }
        }
//        .background(
//            LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
//        )
        .navigationBarBackButtonHidden(true)
        .alert("Request failed. Either the group is full or you already have one request pending. Please cancel pending request.", isPresented: $showCannotSendRequest, actions: {
            Button("OK", role: .cancel, action: {
                
            })
        })
        .alert("Request failed. Group either does not exist or there was a network failure. Please try again later.", isPresented: $showCannotSendRequest, actions: {
            Button("OK", role: .cancel, action: {
                
            })
        })
        .alert("Request failed. Group either does not exist or there was a network failure. Please try again later.", isPresented: $showCannotSendRequest, actions: {
            Button("OK", role: .cancel, action: {
                
            })
        })
        .alert("Cannot create a group when you have a request sent. Please cancel request before creating a group.", isPresented: $showCannotCreateGroup, actions: {
            Button("OK", role: .cancel, action: {
                
            })
        })
        .onAppear(perform: onAppear)

    }
    func onAppear(){
        print("on appear")
        requestViewModel.fetchRequestForClient { result in
            switch result {
            case .success(let requests):
                if requests.groupId != ""{
                    print("i have a request")
                    groupId = requests.groupId
                    requestSent = true
                }
            default :
                print("no requests")
                break
                
            }
        }
        
    }
    func cancelRequest(){
        requestViewModel.cancelRequest {
            groupId = ""
            requestSent = false
        }
        
    }
    func showErrorCantCreateGroupWithRequestSent(){
        if requestSent {
            showCannotCreateGroup = true
        }
    }
    func completeRequest(onCompletion: Result<Bool,DomainError> ){
        isLoading = false
        switch onCompletion{
        case .success(true):
            requestSent = true
            return
        case .success(false):
            showCannotSendRequest = true
            return
        case .failure(_):
            showCannotSendNetworkRequest = true
            return
        }
    }
    func sendInvite(){
        
        if groupId.count < 10 {
            return
        }
        isLoading = true
        
        requestViewModel.canISendRequest(groupId: groupId) { result in
            switch result {
            case .success(true):
                requestViewModel.sendRequest(groupId: groupId, onCompletion: completeRequest)
                
            case .success(false):
                completeRequest(onCompletion: result)
            case .failure(_):
                completeRequest(onCompletion: result)
            }
        }
    }

}

struct NoGroupView_Previews: PreviewProvider {
    static var previews: some View {
        NoGroupView()
    }
}
 
