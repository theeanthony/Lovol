//
//  RequestsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/19/22.
//

import Foundation
import SwiftUI

struct RequestsView : View {
    
    @EnvironmentObject private var requestViewModel : RequestViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showSheet : Bool = false
    

    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(AppColor.lovolTan)
                  
              }
          }
      }
    
    @State private var loadingScreen = false
    
    @State private var requests : [RequestModel] = [RequestModel(id: "0", sendingRequestId: "1", nameOfSender: "Ant", groupId: "1", sendRole: "", isATeam: false),RequestModel(id: "2", sendingRequestId: "3", nameOfSender: "BAnt", groupId: "1", sendRole: "", isATeam: false)]
    @State private var showError : Bool = false
    
    var groupId : String
    
    var body: some View {
        NavigationStack{
            GeometryReader{ geo in
                VStack{
                    ScrollView{
                        if loadingScreen {
                            ProgressView()
                        }
                        else{
                            if requests.isEmpty{
                                Text("No Requests")
                                    .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolDarkPurple)
                                
                            }
                            else{
                                ForEach(requests.indices, id: \.self){ index in
                                    RequestPersonView(request: requests[index], groupId: groupId, requests: $requests, index: index)
                                        .padding()
                                    
                                }
                            }
                            
                        }
                        
                    }
                }
                .frame(width: geo.size.width * 0.95 , height:geo.size.height * 0.95)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color(#colorLiteral(red: 0.9686274528503418, green: 0.8666666746139526, blue: 0.8039215803146362, alpha: 0.800000011920929))))
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)
//                    .frame(width: geo.size.width * 0.9 , height:geo.size.height * 0.9)
      
            }


       
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Requests")
                       .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolDarkPurple)

               }
            }

            .alert("Error loading requests. Please try again.", isPresented: $showError, actions: {
                Button("OK", role: .cancel, action: {
                    
                })
            })
            .onAppear(perform: fetchRequests)
        }
        
    }
    private func fetchRequests(){
        
        requestViewModel.fetchRequestsForGroup(groupId: groupId) { result in
            switch result{
            case .success(let fetchedRequests):
                requests = fetchedRequests
                loadingScreen = false
                
            case .failure(let error):
                print("error fetching requests. \(error)")
                      showError = true
                      
            }
        }
        
    }
    
}
struct RequestsView_Previews: PreviewProvider {
    static var previews: some View {
        RequestsView( groupId: "")
    }
}
