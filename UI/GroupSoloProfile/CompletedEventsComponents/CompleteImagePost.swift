//
//  ImagePost.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/27/22.
//

import SwiftUI

struct CompleteImagePost: View {
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
//    @State private var isCaptionExpanded = false

    @State private var photoIndex : Int = 0
    
    @State private var showBigVersion : Bool = false
    
    var fromProfile : Bool
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing:2){
      

                ZStack{
                    
                    Button {
                        self.showBigVersion = true
                    } label: {
                        AsyncImage(url: URL(string: completedEvent.photoURLS[photoIndex]),
                                   content: { image in
                            image.resizable()
                                .frame(height:geo.size.height )
                                .frame(height:geo.size.width)
                                .onTapGesture(count:2){
                                    like(onTap: true)
                                }
                            
                        },
                                   placeholder: {
                            VStack{
                                ProgressView()
                            }
                                .frame(height:geo.size.height )
                                .frame(width:geo.size.width)
                            
                            
                        }
                                   
                        )
                    }


                }        .frame(height:geo.size.height * 0.75)
                    .frame(height:geo.size.width)
                
                    .fullScreenCover(isPresented: $showBigVersion) {
                        VStack{
                            HStack{
                                Button {
                                    showBigVersion = false
                                } label: {
                                    Image(systemName:"xmark").foregroundColor(.white)

                                }.padding()

                                Spacer()
                            }
                            .padding(.bottom,5 )
                            ScrollView{
                                Spacer()
                                ImagePost(completedEvent: completedEvent,isOverlayShowing:true, fromProfile: fromProfile)
                                    .frame(height:geo.size.height * 5)
                                    .padding(.top, fromProfile ? 10 : 0)

                                VStack(alignment: .leading, spacing: 5) {
                                    HStack{
                                        Text(completedEvent.caption)
                                            .font(.custom("Rubik Regular", size: 14))
                                            .foregroundColor(.white)
                                            .fixedSize(horizontal: false, vertical: true)
                                        //                                    .lineLimit(isCaptionExpanded.wrappedValue ? nil : 2)
                                            .padding(.horizontal, 10)
                                        
                                        Spacer()
                                        
                                    }
                                }
                                .padding(.top, fromProfile ? 5 : -30)
                                Spacer()
                                
                            }
//                            .padding(.top,10)

                            

                        }
                        .background(AppColor.lovolDark)

    
                    }


       

              
  

                
                
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
