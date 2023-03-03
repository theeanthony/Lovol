//
//  ProfileSettingsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/11/22.
//

import SwiftUI

struct ProfileSettingsView: View {
    @EnvironmentObject private var authViewModel : AuthViewModel
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
    var body: some View {
        NavigationStack{
            GeometryReader{geo in
                ScrollView{
                    
//                    Section(header:ListHeader(text:"Settings")){
                        VStack(spacing:15){
                            
                            Group{
                                Button {
                                    
                                } label: {
                                    NavigationLink(destination: EditSoloProfileView())  {
                                        HStack{
                                            Text("Edit Profile")
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                        }
                                    }
                                    
                                }
                                
                                
                                ExDivider(color: .white.opacity(0.5))
                                Button {
                                    
                                } label: {
                                    //                            NavigationLink(destination:  {
                                    HStack{
                                        Text("Contact Us")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                    //                            }
                                    
                                }
                                
                                
                                ExDivider(color: .white.opacity(0.5))
                                Button {
                                    
                                } label: {
                                    //                            NavigationLink(destination: CompletedEventFeedView(groupId:groupId)) {
                                    HStack{
                                        Text("App Feedback")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                    //                            }
                                }
                                
                                
                                ExDivider(color: .white.opacity(0.5))
                                Button {
                                    
                                } label: {
                                    //                            NavigationLink(destination: ChooseEventsFrame(groupId:groupId, currentLovols: teamInfo.teamLovols)) {
                                    HStack{
                                        Text("Community Guidelines")
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }
                                    //                            }
                                }
                            }
                            
                            ExDivider(color: .white.opacity(0.5))
                            Button {
                                
                            } label: {
                                //                            NavigationLink(destination: AllianceFrameExpanded(alliances:$alliances)) {
                                HStack{
                                    Text("Careers")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                //                            }
                                
                                
                            }
                            
                            
                            ExDivider(color: .white.opacity(0.5))
                            Button {
                                
                            } label: {
                                //                            NavigationLink(destination: LeaderBoardFrame(groupId:groupId)) {
                                
                                HStack{
                                    Text("Become a Lovol Ambassador")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                //                            }
                            }
                            
                            
                            
                        }
                        .padding()
                        .frame(width:geo.size.width * 0.85)
                        .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolPinkish))
                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                        .padding(.vertical,10)
//                    }
//                    .frame(width:geo.size.width * 0.95)
//                    Spacer()
                      
                       
                      
                        Button {
                            signout()
                        } label: {
                            Text("Logout")
                                .padding()
                                .frame(width:geo.size.width * 0.85)
                                .foregroundColor(.white)
                                .background(RoundedRectangle(cornerRadius: 30).fill(.gray).opacity(0.6))

                        }
                        .padding(.top,50)
                    Button {
//                        signout()
                    } label: {
                        Text("Delete Account")
                            .padding()
                            .frame(width:geo.size.width * 0.85)
                            .foregroundColor(AppColor.strongRed)

                            

                    }
                    .padding()
                        
                }
                .frame(width:geo.size.width, height:geo.size.height * 0.9)

            }
            .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)

            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                BackgroundView()
            )
            .navigationBarTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Settings")
                       .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)

               }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    private func signout(){
        authViewModel.signOut()
    }
}

struct ProfileSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSettingsView()
    }
}
