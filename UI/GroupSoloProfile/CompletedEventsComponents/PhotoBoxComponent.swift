//
//  PhotoBoxComponent.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/25/23.
//

import SwiftUI

struct PhotoBoxComponent: View {
    let image : FetchedEvent
    var body: some View {
        GeometryReader{geo in
             
//            HStack{
//                Spacer()
                ZStack{
                    
//                    AsyncImage(url: URL(string: image.photoURLS),
//                               content: { image in
//                        image.resizable()
//                            .frame(height:geo.size.width )
//                            .frame(width:geo.size.width )
//                            .background(Rectangle().stroke(.black,lineWidth:1))
//
//
//
//
//
//
//                    },
//                               placeholder: {
//                        ProgressView()
//                            .frame(height:geo.size.width )
//                            .frame(width:geo.size.width )
//
//
//                    })
                    
                    
                }
//                Spacer()
//
//            }
//            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

        }
    }
}

//struct PhotoBoxComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoBoxComponent(image : "https://firebasestorage.googleapis.com:443/v0/b/mygameshow-63e93.appspot.com/o/events_v1%2F01%2Fevent_pic_01.jpg?alt=media&token=3d944260-8ada-4aa3-9141-722d5c78cbfe")
//    }
//}
