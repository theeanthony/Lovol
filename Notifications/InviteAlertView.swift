//
//  InviteAlertView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 3/9/23.
//

import SwiftUI


struct InviteAlertView: View {
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @Binding var teamName : String
    @Binding var groupId : String
//    var message: String
    @Binding var isPresented: Bool
    
    @State private var groupName : String = ""
    @State private var groupPic : UIImage = UIImage()
    
    @State private var isLoading : Bool = false
    @State private var error : Bool = false
    @State private var teamFull : Bool = false
    @State private var picLoaded : Bool = false
    @EnvironmentObject private var appState: AppState

    var body: some View {
        HStack{
            Spacer()
            VStack {
                Spacer()
                if picLoaded {
                    Image(uiImage:groupPic)
                        .resizable()
                        .centerCropped()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())

                        .frame(width:80,height:80)
                    
                        .overlay(Circle().stroke(.white,lineWidth:1))
                }else{

                        Circle().stroke(.white,lineWidth:1)
                        .frame(width:80,height:80)

                }
              
                Text("\(teamName) has invited you to join their team.")
                    .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                    .padding(.bottom, 5)
                Spacer()
//                Text(message)
//                    .padding(.bottom, 20)
                
                Spacer()
                Button(action: {
                    acceptRequest()
                }, label: {
                    Text("Yes")
                        .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                        .padding()
                        .padding(.horizontal,30)
                        .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                })
                Spacer()
                
            }
            Spacer()
        }
        .onAppear(perform: onAppear)
        .padding()
        .background(AppColor.lovolDark)
        .overlay(
            VStack{
                HStack{
                    Button {
//                        presentationMode.wrappedValue.dismiss()
                        self.isPresented = false 
                    } label: {
                        Image(systemName:"xmark").foregroundColor(.white)
                            .padding()
                    }

                    Spacer()
                }
                Spacer()
            })
        .showLoading(isLoading)
        .alert("There has been an error connecting to join the team. Try Again.", isPresented: $error, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
        .alert("This team is full. You cannot join.", isPresented: $teamFull, actions: {
            Button("OK", role: .cancel, action: {
                self.isPresented = false
            })
        })

    }
    private func acceptRequest(){
        isLoading = true
        profileViewModel.joinTeamFromRequest(groupId: groupId) { result in
            switch result {
            case .success(true):
                print("joined team")
                isLoading = false
                self.isPresented = false
                appState.shouldRefresh = true

                return
            case .success(false):
                print("team is full")
                isLoading = false
                return
            case .failure(let error):
                isLoading = false
                print("error joining team \(error)")
                return

            }
        }
    }
    private func onAppear(){
        profileViewModel.fetchGroupMainPicture(profileId: groupId) { result in
            switch result{
            case .success(let teamPic):
                self.groupPic = teamPic
                picLoaded = true
            case .failure(let error):
                print("error fetching team pic \(error)")
            }
        }
    }
}



