//
//  MatchQueueView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/5/22.
//


import SwiftUI

struct MatchQueueView: View {
    let model: MatchModel
    var body: some View {
        VStack(spacing:0){
            Image(uiImage: model.picture).centerCropped().frame(width: 50, height: 50).cornerRadius(25)
                .background(Circle().stroke(lineWidth:2).fill(AppColor.lovolDarkPurple))
            Text(model.name)
                .font(.custom("Rubik Regular", size: 14))
                .foregroundColor(AppColor.lovolDarkPurple)
               

        }

             

    }
}

struct MatchQueueView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MatchSecQueueView(model: MatchModel(id: "fefregergerger",userId: "efwerfgregrger",name: "Elon", birthDate: Date(), picture: UIImage(named:"elon_musk")!, lastMessage: "", isGroup: true))
        }.navigationTitle("Messages")
    }
}
struct MatchMainQueueView: View {
    let model: MatchModel
    var body: some View {
        GeometryReader{ geo in
            VStack(spacing:5){
                Text(model.name)
                    .font(.custom("Rubik Regular", size: 16))
                    .foregroundColor(AppColor.lovolDarkPurple)
                Image(uiImage: model.picture)
                    .resizable()
                    .centerCropped()
                    .clipShape(Circle())
                    .frame(width:geo.size.width, height:geo.size.height)
                 
                    .background(Circle().stroke(lineWidth:2).fill(AppColor.lovolDarkPurple))

 
                
                
            }

        }

             

    }
}
struct MatchSecQueueView: View {
    let model: MatchModel
    var body: some View {
        GeometryReader{ geo in
            VStack(spacing:5){

                Image(uiImage: model.picture)
                    .resizable()
                    .centerCropped()
                    .clipShape(Circle())
                    .frame(width:geo.size.width, height:geo.size.height)
                    .background(Circle().stroke(lineWidth:2).fill(AppColor.lovolDarkPurple))

           
                Text(model.name)
                    .font(.custom("Rubik Regular", size: 16))
                    .foregroundColor(AppColor.lovolDarkPurple)
                
            }
            
//            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

        }

             

    }
}

