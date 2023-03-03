//
//  FeedView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/27/22.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject private var profilesViewModel : ProfilesViewModel

    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel
    @State private var model : [NameAndProfilePic] = []

    @State private var completedEvents : [FetchedEvent] = []
    @State private var loadedPictures : Bool = true
    @EnvironmentObject private var eventViewModel : EventViewModel
    @State private var profilePic : UIImage = UIImage()
    
    @State private var readToEnd = false
        @State private var scrollViewHeight = CGFloat.infinity

        @Namespace private var scrollViewNameSpace
    
    @State private var loadingMore : Bool = false
    @State private var reachedEndOfScroll = false
    
    @State private var feedSelections : [String] = ["Alliances","Global"]
    @State private var selection: String = "Global"
    
    @State private var alliances : [String] = []
    
    @State private var chat : Bool = false
    
    @State private var userIsNotPartOfTeam : Bool = false
    
    var body: some View {
        NavigationStack{
            GeometryReader { geo in

            VStack{

                VStack{
                         Spacer()
                        ScrollView{
                            if loadedPictures{
                                ProgressView()
                            }else{
                                Spacer()
                                if completedEvents.isEmpty {
                                    Text("There are no posts.")
                                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

                                }
                                ForEach(completedEvents.indices, id: \.self){ index in
                                    
                                    
                                    ImagePost(completedEvent: completedEvents[index])
//                                        .frame(height:geo.size.height * 0.90)
                                        .frame(width: geo.size.width, height: geo.size.height)
                                        .padding(.bottom)
                                    
                                }
                                .background(
                                        GeometryReader { proxy in
                                            Color.clear
                                                .onChange(of: proxy.frame(in: .named(scrollViewNameSpace))) { newFrame in
                                                    if newFrame.minY - geo.size.height * 0.2 +  geo.size.height * 0.75 * CGFloat(Float(completedEvents.count)) < geo.size.height * 0.75 {
//                                                        print(" \(newFrame.minY) + \(scrollViewHeight) ")
                                                        readToEnd = true
                                                    }
                                                    
//                                                    print("new frame \(newFrame.minY)")
//                                                    print("newFrame \(newFrame.minY - geo.size.height * 0.2) + \(geo.size.height * 0.8)")
                                                }
                                        }
                                    )
                            }
                            
                            
                        }
                        .frame(width: geo.size.width , height:geo.size.height * 0.95 )
                        .padding(.bottom,10)
                        .padding(.top,5)

                        .background(
                                 GeometryReader { proxy in
                                     Color.clear
                                         .onChange(of: proxy.size, perform: { newSize in
                                             let _ = print("ScrollView: ", newSize)
                                             scrollViewHeight = newSize.height
                                         })
                                 }
                             )
                             .coordinateSpace(name: scrollViewNameSpace)
                        
                    }
                    //                .frame(width:300, height: 300)
                }
                .frame(width:geo.size.width , height: geo.size.height)
//                .background(Rectangle().fill(AppColor.lovolDarkPurple).opacity(0.8))
                
            }
        }

        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .background(BackgroundView())

        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItemGroup(placement:.navigationBarLeading){
                    HStack{
                        Picker("", selection: $selection) {
                            ForEach(feedSelections, id: \.self) {
//                                HStack{
                                    Text($0)
//                                Spacer()
//                                }

                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        .tint(.white)
                        .font(.custom("Rubik Regular", size: 14))
                        .foregroundColor(.white)

                        Spacer()

                    }
            }
            if !userIsNotPartOfTeam{
                ToolbarItemGroup(placement:.navigationBarTrailing){
                    Button {
                        self.chat = true
                    } label: {
                        Image(systemName:"message")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear(perform: initialFetchOrContinueFetch)
        .onChange(of: readToEnd, perform: { newValue in
            fetchMorePhotos()
//            print("fetching more photos")
//            print("Loading more \(loadingMore)")
            self.readToEnd = false 
        })
        .onChange(of: selection, perform: { newValue in
            loadedPictures = true
            completedEvents = []
            loadingMore = false
            eventViewModel.ClearQueryCache()
            eventViewModel.ClearCache()

            fetchMorePhotos()
        })
        .fullScreenCover(isPresented: $chat, content: {
            FrontChatView()
        })
        .alert("Reached end of scrool", isPresented: $readToEnd, actions: {
            Button("OK", role: .cancel, action: {
 
            })
        })
    }
    private func initialFetchOrContinueFetch(){
        let loadedEvents = eventViewModel.fetchCompletedEventsCache()
        if loadedEvents.isEmpty {
            fetchPhotos()
        }else{
            self.completedEvents = loadedEvents
        }
        
        
        
    }
 
    private func fetchMorePhotos(){
        
        if loadingMore{
            return
        }

        
        if selection == "Alliances" && alliances.isEmpty {
            self.completedEvents = []
            return
        }
        self.loadingMore = true

        eventViewModel.checkLiveStatus { result in
            switch result {
            case .success(let status):
                let season = status.season
                eventViewModel.fetchPhotoURLS(alliances: alliances, isGlobal: selection == "Global", events: completedEvents, season: season) { result in
                    switch result {
                    case .success(let photos):
                         
                        
                        loadedPictures = false
                        self.completedEvents.append(contentsOf: photos)
                        loadingMore = false
                        if photos.count == 0 {
                            reachedEndOfScroll = true 
                        }
//                        fetchUsersAndProfilePics()
                    case .failure(let error):
                        print("error fetching photo urls \(error)")
                    }
                }
            case .failure(let error):
                print("error downloading status \(error)")
            }
        }
        
    }
    private func fetchPhotos(){
        profilesViewModel.fetchTeamWithoutID { result in
            switch result {
            case .success(let team):
                self.alliances = team.alliances
                self.alliances.append(team.id)
                
                return
            case .failure(let error):
                print("error fetching alliances \(error)")
                self.userIsNotPartOfTeam = true
                return
            }
        }
        eventViewModel.checkLiveStatus { result in
            switch result {
            case .success(let status):
                let season = status.season
//                print("season check \(season)")
                eventViewModel.fetchPhotoURLS(alliances: alliances, isGlobal:  selection == "Global", events: completedEvents, season: season) { result in
                    switch result {
                    case .success(let photos):
                        loadedPictures = false
                        self.completedEvents = photos
                        
//                        fetchUsersAndProfilePics()
                    case .failure(let error):
                        print("error fetching photo urls \(error)")
                    }
                }
            case .failure(let error):
                print("error downloading status \(error)")
            }
        }
        
    }
    
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
