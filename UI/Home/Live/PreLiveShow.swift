//
//  PreLiveShow.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/20/22.
//

import SwiftUI

struct PreLiveShow: View {
    
    //remember to change this
    @EnvironmentObject private var eventViewModel : EventViewModel
    @State private var isLoading : Bool = true
    @State private var liveStatus : Bool = false
    @State private var isPresented: Bool = false
    @State private var videoURL : String = ""
    @State private var showError : Bool = false 
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

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
    var body: some View {
        NavigationStack{
            VStack{
                
                if isLoading {
                    ProgressView()
                }
                else{
                    if liveStatus {
                        LiveShow(videoURL: videoURL)
                    
                    }
                    else{
                        NotReadyShow()
                    }
                }
                
            }
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("")
            .alert("Error fetching status of the show. Try Again later.", isPresented: $showError, actions: {
                Button("OK", role: .cancel, action: {
                    
                })
            })
            .onAppear(perform: fetchLiveStatus)
        }
    }
    private func fetchLiveStatus(){
        
        eventViewModel.checkLiveStatus { result in
            switch result{
            case .success(let live):

                if live.isActive {
                    videoURL = live.videoURL ?? ""
                    liveStatus = true
                    isLoading = false
                    
                }else{
                    liveStatus = false
                    isLoading = false
                    
                }
                
            case .failure(let error):
                print("error fetching live status \(error)")
                isLoading = false
                showError = true
           
            }
        }
        
        
    }
       
}

struct PreLiveShow_Previews: PreviewProvider {
    static var previews: some View {
        PreLiveShow()
    }
}
