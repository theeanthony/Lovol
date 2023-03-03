//
//  ImagePost.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/27/22.
//

import SwiftUI

struct ImagePost: View {
    var completedEvent : FetchedEvent
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @EnvironmentObject private var eventViewModel : EventViewModel
    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel

    @State private var likeFilled: Bool = false
    @State private var comment : String = ""
    
    @State private var onTap : Bool = false
    
    @State private var profilePic : UIImage = UIImage(named:"elon_musk")!
    @State private var reportPic : Bool = false
    
    @State private var isPresented : Bool = false
    
    @State private var numberOfLikes : Int = 0
    
    @State private var visitProfile : Bool = false
    
    @State private var visitComments : Bool = false
    
    @State private var photoIndex : Int = 0
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing:2){
                VStack(spacing:0){
                    Button {
                        visitProfile = true
                    } label: {
//                        NavigationLink(destination: VisitGroupProfile(groupId:completedEvent.groupId)) {
                            HStack{
                                Image(uiImage: profilePic)
                                    .resizable()
                                    .centerCropped()
                                    .clipShape(Circle())
                                    .frame(width:geo.size.width * 0.125,height:geo.size.width * 0.125)
                                    .background(Circle().stroke(lineWidth:2).foregroundColor(.white).frame(width:geo.size.width * 0.125, height:geo.size.width * 0.125))
                                
                                Text(completedEvent.teamName)
                                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.leading,15)
//                        }

                    }
                    .fullScreenCover(isPresented: $visitProfile) {
                        VisitGroupProfile(groupId:completedEvent.groupId)
                    }
                    


                    
                    Button {
                        self.isPresented = true 
                    } label: {
                            HStack{
                                Spacer()
                                Text(completedEvent.eventName)
                                Spacer()
                            }
//                            .padding(.bottom,10)
                            .font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
                        
                    }
                
                    .fullScreenCover(isPresented: $isPresented) {
                        EventDescriptionView(id:completedEvent.id)
                    }

   
                }
                .frame(height:geo.size.height * 0.3)

                ZStack{
                    
                    AsyncImage(url: URL(string: completedEvent.photoURLS[photoIndex]),
                               content: { image in
                                    image.resizable()
                            .aspectRatio(contentMode: .fit)
                                        .frame(height: geo.size.height * 0.8)
                                        .frame(width: geo.size.width)
                                        .onTapGesture(count:2){
                                            like(onTap: true)
                                        }
                               },
                               placeholder: {
                                    VStack{
                                        ProgressView()
                                    }
                                    .frame(height:geo.size.height * 0.8)
                                    .frame(width:geo.size.width)
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

                    .overlay(
                        HStack{
                            
                            Spacer()
                            
                            VStack{
                                Text("\(photoIndex + 1)/\(completedEvent.photoURLS.count)").opacity(0.6).foregroundColor(.white)
                                    .font(.custom("Rubik Regular", size: 12))

                                Spacer()
                            }
                            
                            Spacer()
                            
                            VStack{
                                Button {
                                    reportPic.toggle()
                                } label: {
                                    Image(systemName: "flag")
                                        .resizable()
                                        .frame(width:20, height:20)
                                        .foregroundColor(.white)
                                }

                                Spacer()
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
                                Text("\(numberOfLikes)")
                                    .foregroundColor(.white)
                                
                                
                            }
//
                        }
                        .padding(.horizontal,7)
                        .padding(.vertical,10)

                    )

                }        .frame(height:geo.size.height * 0.75)
                    .frame(height:geo.size.width)

                VStack{
                    Button {
                        visitProfile = true

                    } label: {
//                        NavigationLink(destination: VisitGroupProfile(groupId:completedEvent.groupId)) {
                            HStack{
                                Text(completedEvent.teamName)
                                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                                Spacer()
                            }
                            .padding(.leading,10)
//                        }
                    }
                    .fullScreenCover(isPresented: $visitProfile) {
                        VisitGroupProfile(groupId:completedEvent.groupId)
                    }

      
                    Button {
                        visitComments = true 
                    } label: {
//                        NavigationLink(destination:CommentsView(eventId: completedEvent.documentId)) {
                            HStack{
                                Text("View \(completedEvent.comments) comments")
                                    .padding(.horizontal,10)
                                Spacer()
                            }
                            .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

//                        }
                        
                    }
                    .fullScreenCover(isPresented: $visitComments) {
                        CommentsView(eventId: completedEvent.documentId)
                    }
                }
//                .padding(.top,5)

                .frame(height:geo.size.height * 0.25)
       

              
  

                
                
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .onAppear(perform: fillHeart)

        }.sheet(isPresented: $reportPic) {
            ReportSheetView(reportId: completedEvent.groupId)
        }

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
        self.likeFilled = completedEvent.didILike
        self.numberOfLikes = completedEvent.likes
        
        profileViewModel.fetchGroupMainPicture(profileId: completedEvent.groupId) { result in
            switch result {
            case .success(let photo):
                self.profilePic = photo
                print("RECEIVED PROFILE PIC AND IS UPLOADING \(photo)")
                return
            case .failure(let error):
                print("error uploading profile pic \(error)")
                return
                
            }
        }
//        self.
 
      
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
