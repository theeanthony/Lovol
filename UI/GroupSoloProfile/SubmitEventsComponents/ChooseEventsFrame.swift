//
//  ChooseEventsFrame.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/25/23.
//

import SwiftUI

struct ChooseEventsFrame: View {
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
    @EnvironmentObject private var eventViewModel : EventViewModel
//    let newColumns = [
//
//        GridItem(.flexible()),
//        GridItem(.flexible()),
//        GridItem(.flexible())
//
//
//     ]
    @State private var totalBits : Int = 0
    @State private var totalLovols: Int = 0
        //add points to fetched events
    let groupId: String
    @State private var fetchedEvents : [CompletedEvent] = []
    @State private var submittedEvents : [CompletedEvent] = []
    @State private var questionSheet : Bool = false
    
    @State private var loading : Bool = true
    
    @State private var loadingPoints : Bool = false
    @State private var zeroError : Bool = false
    @State private var modularError : Bool = false
//    @State private var submittedConfirmed : Bool = false
    let currentLovols : Int
    var body: some View {
        NavigationStack{
            GeometryReader{ geo in
                if loading {
                    ProgressView()
                }else{
                    VStack{
                        HStack{
                            Spacer()
                            VStack{
                                Text("Lovol Bits")
                                    .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
                                
                                Text("\(totalBits)")
                                    .font(.custom("Rubik Bold", size: 32)).foregroundColor(.white)
                                
                            }
                            Spacer()
                            Text("=")
                                .font(.custom("Rubik Bold", size: 32)).foregroundColor(.white)
                            
                            Spacer()
                            VStack{
                                Text("Lovols")
                                    .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
                                
                                Text(totalBits >= 100 ? "\(totalBits/100)" : "0")
                                    .font(.custom("Rubik Bold", size: 32)).foregroundColor(.white)
                            }
                            Spacer()
                        }
                        .padding(.top)
                        ExDivider(color: .white.opacity(0.7))
                            .padding(.vertical)

                        VStack{
                            FilterButtonsPointsView(fetchedEvents: $fetchedEvents)
                                .frame(height:geo.size.height * 0.1)
                            ScrollView{
                                VStack{
                                    ForEach(fetchedEvents.indices,id:\.self){ index in
                                        ChooseEventsSubmitView(event: fetchedEvents[index],totalBits: $totalBits, submittedEvents: $submittedEvents)
                                            .frame(width:geo.size.width, height:geo.size.height * 0.03)
                                        
                                    }
                                }
                                .padding(.top,20)
//                                .frame(width:geo.size.width * 0.95, height:geo.size.height)
                                    
                                
                            }
                 
                            
                            
                            .frame(width:geo.size.width * 0.95, height:geo.size.height * 0.45)
                            
                            
                            Button {
                                submitPoints()
                            } label: {
                                Text("Transfer")
                                    .padding()
                                    .frame(width:geo.size.width * 0.8)
                                    .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolDarkerPurpleBackground))
                                    .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
                                
                                
                            }
                            .padding()
                            
                        }
                        .frame(height:geo.size.height * 0.7)
                    }   .frame(height:geo.size.height )
                }
            }
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [ AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
        )
        
        
        .onAppear(perform:onAppear)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
           ToolbarItemGroup(placement: .navigationBarTrailing) {
               HStack{
                   Button {
                       questionSheet.toggle()
                   } label: {
                       Image(systemName: "questionmark.circle.fill").foregroundColor(.white)
                   }
               }


           }
        }
        .sheet(isPresented: $questionSheet) {
            SubmitQuestionSheet()
                .presentationDetents([ .large])
                    .presentationDragIndicator(.hidden)
            

        }
        .showLoading(loadingPoints)
        .alert("Please choose events to submit.", isPresented: $zeroError, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
        .alert("Please submit lovol bits that is a multiple of 100.", isPresented: $modularError, actions: {
            Button("OK", role: .cancel, action: {

            })
        })
    }
    private func onAppear(){
        eventViewModel.fetchCompletedEventsForSubmissions(groupId: groupId) { result in
            switch result {
            case .success(let completed):
                self.fetchedEvents = completed
                self.loading = false
                return
            case .failure(let error):
                print("error fetching completing events \(error)")
                return
            }
        }
    }
    private func submitPoints(){
        if totalBits == 0{
            self.zeroError = true
        }else if totalBits % 100 != 0 {
            self.modularError = true
        }else{
            loadingPoints = true
            eventViewModel.submitPoints(groupId: groupId, points: totalBits, submittedEvents: submittedEvents) { result in
                switch result {
                case .success(()):
                    
                    filterOutSubmittedEvents()
                    loadingPoints = false
                    self.totalBits = 0
                    self.totalLovols = 0
//                    self.submittedConfirmed = true

                    return
                case .failure(let error):
                    print("error submitting points \(error)")
                    loadingPoints = false

                    return
                }
            }
        }
        
    }
    private func filterOutSubmittedEvents(){
        
        self.fetchedEvents = fetchedEvents.filter { !submittedEvents.contains($0) }
        

    }
}

struct ChooseEventsFrame_Previews: PreviewProvider {
    static var previews: some View {
        ChooseEventsFrame(groupId: "", currentLovols: 0)
    }
}
