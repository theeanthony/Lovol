//
//  RequestSectionView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/16/23.
//

import SwiftUI

struct RequestSectionView: View {
    let groupId : String
    @Binding var requests : [RequestModelPicture]
    var body: some View {
        GeometryReader{ geo in
            VStack{
                VStack{

                    HStack{
                        Spacer()
  
                        
                        //maxName size 10 characters
                        if requests.isEmpty {
                            VStack{
                                Spacer()
                                Text("No Requests").font(.custom("Rubik Regular", size: 16)).foregroundColor(.white)
                                Spacer()
                            }
                        }else{
                            RequestMemberView(editableRequests:$requests)
                        }
                       
     
                        Spacer()
                        
                    }
                }
                .padding()
//                .background(AppColor.lovolDarkerPurpleBackground)
                
            }
        }
        
  
    }
}

//struct RequestSectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestSectionView(groupId: "")
//    }
//}
