//
//  InviteFriendsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/17/23.
//

import SwiftUI

struct InviteFriendsLabelView: View {
    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel
    @State private var urlString : URL = URL(string: "https://lovolac.com")!
    
    @State private var isPresented : Bool = false

    let groupId : String
    var body: some View {
        
        VStack{
            VStack{
                HStack{
                    Text("Invite friends to get extra")
                        .font(.custom("Rubik Bold", size: 16)).foregroundColor(.white)
                    Spacer()
                }
                HStack{
                    Text("Lovol Bits")
                        .font(.custom("Rubik Bold", size: 16)).foregroundColor(.white)
                    Spacer()
                }
                .padding(.bottom,5)
                HStack{
                    Text("Invite a friend to get 10 extra Lovol Bits for")
                        .font(.custom("Rubik Regular", size: 11)).foregroundColor(.white).opacity(0.8)
                    Spacer()
                }
                HStack{
                    Text("your team")
                        .font(.custom("Rubik Regular", size: 11)).foregroundColor(.white).opacity(0.8)
                    Spacer()
                }
                .padding(.bottom,5)
                HStack{
                    Spacer()
                    Text("Invitation code: ")
                        .font(.custom("Rubik Regular", size: 11)).foregroundColor(.white).opacity(0.8)
                    Button {
                        UIPasteboard.general.string = groupId
                        
                    } label: {
                        Text("\(groupId)")
                            .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                        Image(systemName:"doc.on.clipboard.fill").foregroundColor(.white)
                    }
                    
                    
                    
                    Spacer()
                }
            }.padding(.leading,15)
            HStack{
                Spacer()
                ShareLink( "Invite", item: urlString)
                    .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white).multilineTextAlignment(.center)
                    .padding()
                    .padding(.horizontal,60)
                    .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))
                    .contentShape(RoundedRectangle(cornerRadius: 30))

                Spacer()

            }
//            HStack{
//                Spacer()
//                Button {
//
//                } label: {
//                    Text("Invite")
//
//                        .font(.custom("Rubik Bold", size: 16)).foregroundColor(.white)
//
//                }
//                Spacer()
//            }

        }

        .onAppear(perform: onAppear)
        
      
    }
    private func onAppear(){
        firestoreViewModel.shareTapped(groupId) { url in
            self.urlString = url
        }
    }
}

struct InviteFriendsLabelView_Previews: PreviewProvider {
    static var previews: some View {
        InviteFriendsLabelView(groupId: "")
    }
}
