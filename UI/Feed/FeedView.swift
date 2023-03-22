//
//  FeedView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/27/22.
//

import SwiftUI

struct FeedView: View {
    @Binding var tag : Int
    @EnvironmentObject private var profilesViewModel : ProfilesViewModel

    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel

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
    @State private var selection: String = "Alliances"
    
    @State private var alliances : [String] = []
    
    @State private var chat : Bool = false
    
    @State private var userIsNotPartOfTeam : Bool = false
    
    @State private var noMoreDocuments : Bool = false
    @State private var isCaptionExpanded = false
    
    @State private var captionDic : [Int : Bool] = [:]

    @State private var captionLineCounts: [Int: Int] = [:]

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
                                if completedEvents.isEmpty && !userIsNotPartOfTeam{
                                    Text("There are no posts.")
                                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

                                }
                                if selection == "Alliances" && userIsNotPartOfTeam {
                                    VStack{
                                        Button {
                                            self.tag = 4
                                        } label: {
                                            HStack{
                                                Text("Join or create a team to see alliance posts")
                                                Image(systemName:"chevron.right").foregroundColor(.white)
                                            }
                                            
                                        }
                                        .padding(.vertical)
                                        .padding(.vertical)

                                        Text("Or")
                                            .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)

                                            .padding(.vertical)
                                            .padding(.vertical)
                                        Button {
                                            self.selection = "Global"
                                        } label: {
                                            HStack{
                                                Text("Check out the global feed")
                                                Image(systemName:"chevron.right").foregroundColor(.white)
                                            }
                                        }
                                        .padding(.top)
                                        .padding(.top)

                               

                                    }
                                    .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)

                                    .padding(.vertical,60)
                                        

                                }else{
                                    ForEach(completedEvents.indices, id: \.self) { index in
                                        let isCaptionExpanded = Binding<Bool>(
                                            get: { self.captionDic[index] ?? false },
                                            set: { self.captionDic[index] = $0 }
                                        )
                                        
                                        VStack(alignment: .leading, spacing: 10) {
                                            ImagePost(completedEvent: completedEvents[index], isOverlayShowing: false, fromProfile: false)
                                                .frame(width: geo.size.width, height: geo.size.height)
                                            
                                            VStack(alignment: .leading, spacing: 5) {
                                                Text(completedEvents[index].caption)
                                                    .font(.custom("Rubik Regular", size: 14))
                                                    .foregroundColor(.white)
                                                    .fixedSize(horizontal: false, vertical: true)
                                                    .lineLimit(isCaptionExpanded.wrappedValue ? nil : 2)
                                                    .padding(.horizontal, 10)
                                                    .background(
                                                        GeometryReader { proxy in
                                                            Color.clear
                                                                .onAppear {
                                                                    let font = UIFont(name: "Rubik Regular", size: 14)
                                                                    let maxLineCount = 2
                                                                    let width = proxy.size.width - 20 // subtract left and right padding
                                                                    let text = completedEvents[index].caption
                                                                    let lineCount: Int
                                                                    if let font = font {
                                                                        lineCount = text.lineCount(forWidth: width, font: font)
                                                                    } else {
                                                                        lineCount = text.lineCount(forWidth: width, font: .systemFont(ofSize: 14))
                                                                    }
                                                                    captionLineCounts[index] = lineCount

                                                                }
                                                        }
                                                    )
                                                HStack{
                                                    Spacer()
                                                    if captionLineCounts[index] ?? 0 > 2 {
                                                        
                                                        
                                                        Button(action: {
                                                            isCaptionExpanded.wrappedValue.toggle()
                                                        }) {
                                                            if isCaptionExpanded.wrappedValue {
                                                                // Hide the chevron down image when the full caption is shown
                                                                Color.clear
                                                                    .frame(width: 20, height: 20)
                                                            } else {
                                                                // Show the chevron down image when the caption is truncated
                                                                //                                                            HStack{
                                                                //                                                                Spacer()
                                                                Image(systemName: "chevron.down")
                                                                    .font(.custom("Rubik Regular", size: 14))
                                                                    .foregroundColor(.white)
                                                                    .padding(.trailing, 10)
                                                                    .frame(width: 20, height: 20)
                                                                //                                                            Spacer()
                                                                //                                                            }
                                                            }
                                                        }
                                                        .frame(width: 20, height: 20)
                                                        .padding(.top, 5)
                                                    }
                                                    Spacer()
                                                }
                                            }
                                            .padding(.top,-5)
                                        }
                                        
//                                        .background(AppColor.lovolDark.opacity(0.5))
                                    }
                                    
                                    
                                    






                                .background(
                                        GeometryReader { proxy in
                                            Color.clear
                                                .onChange(of: proxy.frame(in: .named(scrollViewNameSpace))) { newFrame in
                                                    if newFrame.minY - geo.size.height * 0.2 +  geo.size.height * 0.9 * CGFloat(Float(completedEvents.count)) < geo.size.height * 0.9 {
//                                                        print(" \(newFrame.minY) + \(scrollViewHeight) ")
                                                        readToEnd = true
                                                    }
                                                    
//                                                    print("new frame \(newFrame.minY)")
//                                                    print("newFrame \(newFrame.minY - geo.size.height * 0.2) + \(geo.size.height * 0.8)")
                                                }
                                        }
                                    )
                                if reachedEndOfScroll {
                                    Text("No more posts.")
                                        .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                                        .padding(.vertical)

                                    }
                                }

                            }
                            
                            
                        }
                        .scrollIndicators(.hidden)
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
                            ForEach(feedSelections, id: \.self) { feedSelection in
                                HStack{
                                Text(feedSelection)
                                Image(systemName:"chevron.down").foregroundColor(.white)

//                                Spacer()
                                }

                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        .tint(.white)
                        .font(.custom("Rubik Regular", size: 14))
                        .foregroundColor(.white)
//                        Image(systemName:"chevron.down").foregroundColor(.white)

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
            print()
            print("fetching more photos")
//            print("Loading more \(loadingMore)")
            self.readToEnd = false 
        })
        .onChange(of: selection, perform: { newValue in
            loadedPictures = true
            completedEvents = []
            loadingMore = false
            eventViewModel.ClearQueryCache()
            eventViewModel.ClearCache()
            reachedEndOfScroll = false
            captionDic.removeAll()

            fetchMorePhotos()
        })
        .fullScreenCover(isPresented: $chat, content: {
            FrontChatView()
        })

    }
//    private func shouldShowMoreButton(geo: GeometryProxy) -> Bool {
//        let size = geo.size
//        let constraintSize = CGSize(width: size.width, height: .infinity)
//        let captionHeight = completedEvent.caption.boundingRect(with: constraintSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height
//        return !isCaptionExpanded && captionHeight > 40
//    }
    private func initialFetchOrContinueFetch(){
        let loadedEvents = eventViewModel.fetchCompletedEventsCache()
        if loadedEvents.isEmpty {
            fetchPhotos()
        }else{
            self.completedEvents = loadedEvents
        }
        
        
        
    }

    private func fetchMorePhotos(){
        
        if loadingMore || reachedEndOfScroll{
//            print("alreaedy fetching")
            return
        }

        
        if selection == "Alliances" && alliances.isEmpty {
            self.completedEvents = []
            loadedPictures = false

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
                         
                        
                        self.completedEvents.append(contentsOf: photos)
                        loadedPictures = false

                        loadingMore = false
                        if photos.count == 0 {
                            
                            print("reached end")
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
                print("alliances of team in fetchphots \(alliances)")
                self.alliances.append(team.id)
                self.userIsNotPartOfTeam = false
                if selection == "Alliances" && alliances.isEmpty {
                    self.completedEvents = []
                    loadedPictures = false

                    return
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
        //                        for completedEvent in completedEvents {
        //                        }
                                
        //                        fetchUsersAndProfilePics()
                            case .failure(let error):
                                print("error fetching photo urls \(error)")
                            }
                        }
                    case .failure(let error):
                        print("error downloading status \(error)")
                    }
                }
                
//                return
            case .failure(let error):
                print("error fetching alliances \(error)")
                self.userIsNotPartOfTeam = true
                self.completedEvents = []
                loadedPictures = false
                self.alliances = []

                return
            }
        }

        
    }
    
}

//struct FeedView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedView()
//    }
//}
extension String {
    func lineCount(forWidth width: CGFloat, font: UIFont) -> Int {
        let constrainedSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let boundingRect = self.boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        let lineHeight = font.lineHeight
        return Int(boundingRect.height / lineHeight)
    }
}
