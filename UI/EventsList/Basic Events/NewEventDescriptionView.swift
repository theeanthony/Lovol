//
//  NewEventDescriptionView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/15/23.
//

import SwiftUI

struct NewEventDescriptionView: View {
  let pic : String
    var body: some View {
        VStack{
            GeometryReader { geo in
                AsyncImage(url: URL(string: pic),
                           content: { image in
                    image.resizable()
                        .centerCropped()
                        .frame(height:geo.size.width)
                    
                        .background(AppColor.lovolPinkish)

                    
                    
                    
                    
                },
                           placeholder: {
                    ProgressView()
                        .frame(height:geo.size.height * 0.4)
//                        .frame(height:geo.size.height)

                        .frame(width:geo.size.width)
//                        .background(AppColor.lovolPinkish)

                    
                    
                })
//                .frame(height:geo.size.height )

//                            .position(x:UIScreen.main.bounds.width/2,y:  geo.frame(in: .local).minY )
                .position(x:UIScreen.main.bounds.width/2,y:  geo.size.height / 8 )
             
                
            }
            Spacer()
        }
            
            
        
    }
}

struct NewEventDescriptionView_Previews: PreviewProvider {
    static let pic : String = "https://firebasestorage.googleapis.com/v0/b/mygameshow-63e93.appspot.com/o/eventPictures%2FeventCharades.jpeg?alt=media&token=62ef0c18-80b9-46b0-b959-8f6ab48c713d"
    static var previews: some View {
        NewEventDescriptionView(pic:pic)
    }
}
