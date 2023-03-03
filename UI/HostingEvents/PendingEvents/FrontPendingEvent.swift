//
//  FrontPendingEvent.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/21/23.
//

import SwiftUI

struct FrontPendingEvent: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @EnvironmentObject private var eventViewModel : EventViewModel
    let groupId: String
    @State private var hostedEvents : [HostEvent] = []
//    @State private var pastEvents : [HostEvent] = []
    @State private var loading : Bool = true
    
    @State private var errorLoading : Bool = false
    var body: some View {
        VStack{
            if loading {
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        ProgressView()

                        Spacer()
                    }
                    Spacer()
                }
            }else{
                
                VStack{
                    HStack{
                        Text("Pending Events...")
                            .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                        Spacer()
                    }
                    ScrollView{
                        
                        ForEach(hostedEvents.indices,id:\.self){
                            event in
                            
                            PendingEventLabel(event: hostedEvents[event],groupId:groupId, hostedEvents: $hostedEvents, index:event)
                            
                            
                        }
                        
                    }
                    .padding(.top,10)
                    
                }
                .padding()
                .padding(.top,20)
            }

        }
        .overlay(
            VStack{
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName:"xmark").foregroundColor(.white)
                    }
                    .padding()

                    Spacer()
                }
                Spacer()

            }
        )
        .background(
        BackgroundView()
        )

        .alert("There has been an error retrieving your teams pending events.", isPresented: $errorLoading, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
        .onAppear(perform:fetchPendingEvents)
    }
    private func fetchPendingEvents(){
        eventViewModel.fetchPendingEvents(groupId: groupId) { result in
            switch result {
            case .success(let events):
                
                self.hostedEvents = events
                loading = false
            case .failure(let error):
                print("error fetching pending events \(error)")
                self.errorLoading = true
                loading = false 
                return
            }
        }

    }
    
}

struct FrontPendingEvent_Previews: PreviewProvider {
    static var previews: some View {
        FrontPendingEvent(groupId: "")
    }
}
