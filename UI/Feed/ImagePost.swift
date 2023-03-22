//
//  ImagePost.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/27/22.
//

import SwiftUI
import AVKit

struct ImagePost: View {
    var completedEvent : FetchedEvent
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @EnvironmentObject private var eventViewModel : EventViewModel
    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel

    @State private var likeFilled: Bool = false
    @State private var comment : String = ""
    
    @State private var onTap : Bool = false
    
    @State private var profilePic : UIImage = UIImage()
    @State private var reportPic : Bool = false
    
    @State private var isPresented : Bool = false
    
    @State private var numberOfLikes : Int = 0
    
    @State private var visitProfile : Bool = false
    
    @State private var visitComments : Bool = false
    
    @State private var photoIndex : Int = 0
    
    @State private var loadedProfilePic : Bool = false
    @State private var isCaptionExpanded = false
    @State private var showCaption : Bool = false
    
    @State private var otherGroupId : String = ""

    var isOverlayShowing : Bool // track whether overlay is showing
    var fromProfile : Bool
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var offset: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            VStack(spacing:2){
                VStack(spacing:0){
                    HStack{
                        Button {
                            visitProfile = true
                        } label: {
                            //                        NavigationLink(destination: VisitGroupProfile(groupId:completedEvent.groupId)) {
                            
                            if loadedProfilePic{
                                Image(uiImage: profilePic)
                                    .resizable()
                                    .centerCropped()
                                    .clipShape(Circle())
                                    .frame(width:geo.size.width * 0.1,height:geo.size.width * 0.1)
                                    .background(Circle().stroke(lineWidth:2).foregroundColor(.white).frame(width:geo.size.width * 0.115, height:geo.size.width * 0.115))
                            }else{
                                Circle().fill(.clear)
                                    .frame(width:geo.size.width * 0.1,height:geo.size.width * 0.1)
                                    .background(Circle().stroke(lineWidth:2).foregroundColor(.white).frame(width:geo.size.width * 0.115, height:geo.size.width * 0.115))
                            }
                            
                            
                            Text(completedEvent.teamName)
                                .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                            Spacer()
                            
                            //                        }
                            
                        }
                        .fullScreenCover(isPresented: $visitProfile) {
                            OtherTeamProfileView(groupId:$otherGroupId)
                        }
                        Text("completed ")
                            .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

                        Button {
                            self.isPresented = true
                        } label: {
                   
                                Text(completedEvent.eventName)
                            //                            .padding(.bottom,10)
                            .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                            
                        }
                        
                        .fullScreenCover(isPresented: $isPresented) {
                            EventDescriptionView(id:completedEvent.id)
                        }
                        Spacer()

                    }
                    .padding(.horizontal,5)
                    


        
 
   
                }
                .frame(height:geo.size.height * 0.3)

                ZStack{
                    
                    if let videoURL = URL(string: completedEvent.photoURLS[photoIndex]), videoURL.isVideoURL {
//                        VideoPlayer(player: AVPlayer(url: URL(string: completedEvent.photoURLS[photoIndex])!))
//                        VideoPlayerView(videoURL: URL(string: completedEvent.photoURLS[photoIndex])!)
                        VideoPlayerView(player: AVPlayer(url: URL(string: completedEvent.photoURLS[photoIndex])!))

                            .frame(height: geo.size.height * 0.8)
                            .frame(width: geo.size.width)
                            .onTapGesture(count: 2) {
                                like(onTap: true)
                                
                            }
                   
                            .gesture(DragGesture()
                                              .onEnded({ value in
                                                  if value.translation.width > 0 {
                                                      goThroughPhotos(right: false)
                                                  } else {
                                                      goThroughPhotos(right: true)
                                                  }
                                              })
                                          )
                    } else {
                        AsyncImage(url: URL(string: completedEvent.photoURLS[photoIndex]),
                                   content: { image in
//                                        if let uiImage = image.image {
//                                            Image(uiImage: uiImage)
                                                image.resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: geo.size.height * 0.8)
                                                .frame(width: geo.size.width)
                                                .onTapGesture(count: 2) {
                                                    like(onTap: true)
                                                }
//                                        }
                                   },
                                   placeholder: {
                                        VStack {
                                            ProgressView()
                                        }
                                        .frame(height: geo.size.height * 0.8)
                                        .frame(width: geo.size.width)
                                   }
                        )
                        .gesture(DragGesture()
                                          .onEnded({ value in
                                              if value.translation.width > 0 {
                                                  goThroughPhotos(right: false)
                                              } else {
                                                  goThroughPhotos(right: true)
                                              }
                                          })
                                      )
                    }
                    




                    

                }
             
                    .frame(height:geo.size.width)
                
      
                Spacer()

                VStack{
                    
                    HStack{
                        Button {
                            like(onTap: false)
                        } label: {

                            if likeFilled{
                                Image(systemName: "heart.fill")
                                    .resizable()
                                    .frame(width:20, height:20)
                                    .foregroundColor(.red)
                            }else{
                                Image(systemName: "heart")
                                    .resizable()
                                    .frame(width:20, height:20)
                                    .foregroundColor(.white)
                                
                            }

                        }
//                        Text("\(numberOfLikes)")
//                            .foregroundColor(.white)
                        Button {
                            visitComments = true

                        } label: {
//                                    NavigationLink(destination:CommentsView(eventId: completedEvent.documentId)) {
                                Image(systemName: "ellipsis.bubble.fill")
                                    .resizable()
                                    .frame(width:20, height:20)
                                    .foregroundColor(.white)

//                                    }

                        }
                        .fullScreenCover(isPresented: $visitComments) {
                            CommentsView(eventId: completedEvent.documentId)
                        }
                        Spacer()
                        HStack(spacing: 8) {
                            
                            if completedEvent.photoURLS.count > 1 {
                                ForEach(0..<completedEvent.photoURLS.count, id: \.self) { index in
                                    
                                    
                                    Circle()
                                        .fill(photoIndex == index ? Color.white : Color.gray)
                                        .frame(width: 8, height: 8)
                                }
                            }
                    
                          }
                        Spacer()
                        Button {
                            reportPic.toggle()
                        } label: {
                            Image(systemName: "flag")
                                .resizable()
                                .frame(width:17, height:17)
                                .foregroundColor(.white)
                        }

//                        Spacer()
                        
                    }
                    .padding(.horizontal,10)
                    
                    HStack{
                    Button {
                        visitProfile = true

                    } label: {
                        Text(completedEvent.teamName)
                            .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)
                        //                        NavigationLink(destination: VisitGroupProfile(groupId:completedEvent.groupId)) {
                    }
                            .padding(.leading,10)
                        Spacer()

//                        }
                        
                    }

                    
//                    .fullScreenCover(isPresented: $visitProfile) {
//                        VisitGroupProfile(groupId:completedEvent.groupId)
//                    }


      
                    HStack{

                    Button {
                        visitComments = true 
                    } label: {
//                        NavigationLink(destination:CommentsView(eventId: completedEvent.documentId)) {
                                Text("View \(completedEvent.comments) comments")
                                    .padding(.horizontal,10)
                            .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

//                        }

                        }
                        Spacer()

                    }

                    .fullScreenCover(isPresented: $visitComments) {
                        CommentsView(eventId: completedEvent.documentId)
                    }
                    
                    
                }
//                .padding(.top,5)

                .frame(height:geo.size.height * 0.3)
                
//                VStack{
//                    Text(completedEvent.caption)
//                        .font(.custom("Rubik Regular", size: 14))
//                        .foregroundColor(.white)
//                        .lineLimit(completedEvent.showCaption ? nil : 2)
//                }
//                .frame(height: geo.size(for: completedEvent.caption))

       

              
  

                
                
            }
            .padding(.top,5)

            .frame(width: geo.size.width, height: geo.size.height)
            .onAppear(perform: fillHeart)

        }.sheet(isPresented: $reportPic) {
            ReportSheetView(reportId: completedEvent.groupId)
        }
        .background(AppColor.lovolDark)

    }
    private func goThroughPhotos(right:Bool){
        
        
        if right {
            if photoIndex < completedEvent.photoURLS.count - 1 {
                photoIndex += 1
            }
        }
        else{
            if photoIndex > 0 {
                photoIndex -= 1
            }
        }
    }

    private func fillHeart(){
        self.otherGroupId = completedEvent.groupId
        self.likeFilled = completedEvent.didILike
        self.numberOfLikes = completedEvent.likes
        
        profileViewModel.fetchGroupMainPicture(profileId: completedEvent.groupId) { result in
            switch result {
            case .success(let photo):
                
                self.profilePic = photo
                loadedProfilePic = true
                print("RECEIVED PROFILE PIC AND IS UPLOADING \(photo)")
                return
            case .failure(let error):
                print("error uploading profile pic \(error)")
                return
                
            }
        }
//        self.
 
      
    }
    private func shouldShowMoreButton(geo: GeometryProxy) -> Bool {
        let size = geo.size
        let constraintSize = CGSize(width: size.width, height: .infinity)
        let captionHeight = completedEvent.caption.boundingRect(with: constraintSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.height
        return !isCaptionExpanded && captionHeight > 40
    }
    private func like(onTap: Bool){
        
        if likeFilled {
            if onTap {
                self.onTap = false
                return
            }
            else{
                self.likeFilled = false
                self.numberOfLikes -= 1

                eventViewModel.dislikeEvent(id: completedEvent.documentId) {

                    return
                }
            }
        }
        else{
            self.likeFilled = true
            self.onTap = false
            self.numberOfLikes += 1

            eventViewModel.likeEvent(id: completedEvent.documentId) {
//                self.likeFilled = true
//                self.onTap = false
                return
            }
        }
        
        
        
        
        
    }

}
//
//struct ImagePost_Previews: PreviewProvider {
//    
//    static var previews: some View {
//        ImagePost(completedEvent: FetchedEvent(photoURLS: "https://media.istockphoto.com/id/1401715576/photo/orange-balls-fall-from-the-sky-and-bouce-of-the-ground.jpg?s=1024x1024&w=is&k=20&c=Z1lcYUasUiRAQOvGNpwhBdSHlRhuGsXEiETyPXGONGw=", groupId: "123", eventName: "tig", eventType: "Home", eventMonth: "", teamName: "Letsgo", id: "", likes: 5, comments: 1, didILike: true))
//    }
//}
//I love Anthony. He is so handsome. [enter as "handsome boyfriend"] [rename "handsome boyfriend" to "sexy mofo"]
