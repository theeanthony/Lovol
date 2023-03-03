//
//  EnlargedPhotoView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/9/23.
//

import SwiftUI

struct EnlargedPhotoView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @Binding var image : String

    var body: some View {
        GeometryReader{geo in
             
//            HStack{
//                Spacer()
            VStack{
                HStack{
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName:"xmark")
                            .foregroundColor(.white)
                    }
               

                    Spacer()
                }.padding(.leading,20)
                    Spacer()
                ZStack{
                    
                    AsyncImage(url: URL(string: image),
                               content: { image in
                        image.resizable()
                            .frame(height:geo.size.width )
                            .frame(width:geo.size.width )
                            .background(Rectangle().stroke(.black,lineWidth:1))
                        
                        
                        
                        
                        
                        
                    },
                               placeholder: {
                        ProgressView()
                            .frame(height:geo.size.width )
                            .frame(width:geo.size.width )
                        
                        
                    })
                }
                Spacer()
//
            }
            .frame(width:geo.size.width, height:geo.size.height)
            .background(.black.opacity(0.3))
//            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

        }
    }
}

//struct EnlargedPhotoView_Previews: PreviewProvider {
//    static var previews: some View {
//        EnlargedPhotoView(image: FetchedEvent(photoURLS: "https://firebasestorage.googleapis.com:443/v0/b/mygameshow-63e93.appspot.com/o/events_v1%2F28F0EB240B%2Fevent_pic_03.jpg?alt=media&token=8b1f5205-b1c9-4352-ac08-1d1813d6c2c4", groupId: "", eventName: "", eventType: "", eventMonth: "", teamName: "", id: "", likes: 0, comments: 0, didILike: false, timeStamp: ""))
//    }
//}
