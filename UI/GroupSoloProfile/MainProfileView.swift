//
//  MainProfileView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import SwiftUI

struct MainProfileView: View {
    @EnvironmentObject private var appState: AppState

    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @State private var loadingProfileCheck : Bool = true
    
    @State private var inGroup : Bool = false
    
    @State private var profileGroupInformation : FirestoreGroup = FirestoreGroup()
    
    @State private var name : String = ""
    @State private var id: String = ""
    @State private var role : String = ""
    @State private var groupId : String = ""
    @State private var confirmLeave : Bool = false
    @State private var leaveError : Bool = false
    
    @State private var isloading : Bool = false
    var refreshAction: (() -> Void)?

    var body: some View {
        NavigationStack{
            GeometryReader{geo in
                VStack{
                    if loadingProfileCheck {
                        ProgressView()
                    }else{
                        
                        if inGroup{
                            FrontProfileView(name:name, groupId: groupId)
                        }else{
                            NewToGameView(name:name, id:id, role: role, teamCreatedOption: $inGroup)
                        }
                        
                    }
                }
                .frame(width:geo.size.width ,height:geo.size.height)
                .background(BackgroundView())

                .onAppear(perform: onAppear)
                
            }
            .toolbar{
                
                ToolbarItemGroup(placement: .navigationBarLeading){
                    Text("Lovol")
                        .font(.custom("Rubik Bold", size: 18)).foregroundColor(.white)
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack{
                        Button {
                        } label: {
                            NavigationLink(destination: ProfileSettingsView()) {
                                Image(systemName: "person.circle.fill").foregroundColor(.white)
                                    .transaction { transaction in
                                        transaction.animation = nil
                                    }

                            }
                        }
                        if inGroup{
                            Button {
                                self.confirmLeave = true
                            } label: {
                                    Image(systemName: "arrowshape.turn.up.left.fill").foregroundColor(.white)
                                        .transaction { transaction in
                                            transaction.animation = nil
                                        }

                            }
                        }
                    }
                    
                    
                }

            }
        }
        .onChange(of: appState.shouldRefresh) { _ in
                  onAppear()
                  appState.shouldRefresh = false
              }
        .alert("Are you sure you want to leave this team?", isPresented: $confirmLeave, actions: {
            Button("Yes", role: .none, action: {
                leaveTeam()
            })
            Button("No",role:.cancel, action:{
                self.confirmLeave = false
            })
        })
        .alert("There was an error leaving this team. Try again.", isPresented: $leaveError, actions: {
            Button("OK", role: .cancel, action: {
                self.leaveError = false

            })
        })
        .showLoading(isloading)
        
        
    }
        
    func refreshData() {
        
          // Implement refresh logic for your view here
      }
    private func leaveTeam(){
        isloading = true
        profileViewModel.leaveTeam(groupId: groupId) { result in
            switch result{
            case .success(()):
                self.inGroup = false
                self.profileGroupInformation = FirestoreGroup()
                isloading = false
            case .failure(let error):
                print("unable to eleave \(error)")
                self.leaveError = true
                isloading = false

            }
        }
    }
    private func onAppear(){
      
        profileViewModel.fetchMember { result in
            switch result{
            case .success(let user):
                self.groupId = user.groupId
                self.name = user.name
                self.role = user.role
                self.id = profileViewModel.fetchUserId()
                if groupId == "" {
                    self.inGroup = false
                }else{
                    self.inGroup = true
                    self.groupId = groupId
                }
                loadingProfileCheck = false
                return
            case .failure(let error):
                print("Error fetching user to check group profile \(error)")
                return
            }
        }    }
}

struct MainProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MainProfileView()
    }
}
class AppState: ObservableObject {
    @Published var shouldRefresh = false
}
