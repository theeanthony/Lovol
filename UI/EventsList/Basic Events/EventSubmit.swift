//
//  EventSubmit.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/16/22.
//

import SwiftUI

struct EventSubmit: View {
    
   
     var image : UIImage?
    var initialImage : UIImage
    @Binding var showSheet : Bool

    var body: some View {
        ZStack{
        
//            RoundedRectangle(cornerRadius: 10).fill(Color(#colorLiteral(red: 0.21176470816135406, green: 0.12156862765550613, blue: 0.40784314274787903, alpha: 0.4000000059604645)))
////                .frame(width: 335, height: 70)
//                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)


                Group{
                    ZStack{
                        
                        Button {
                            showSheet = true 
                            
                        } label: {
                            Group{
                                ZStack{
                                    if image == initialImage {
                                        Circle().fill(AppColor.lovolTan)
                                            .frame(width:80, height:80)
                                    }
                                    else{
                                        Image(uiImage: image!)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .clipShape(Circle())
                                                .frame(width:80, height:80)

                                    }
                                    Circle().stroke(AppColor.lovolPinkish, lineWidth: 2)
                                        .frame(width:80, height:80)

                                    

                                }
                            }
                            .frame(width: 80, height: 40)
                            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
                        }
                    }
                }
         
        }
    }
}

//struct EventSubmit_Previews: PreviewProvider {
//    static var previews: some View {
//        EventSubmit(image: UIImage(named: "elon_musk")!)
//    }
//}
