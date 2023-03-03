//
//  EditLocationView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/1/23.
//



import SwiftUI

struct EditLocationView: View {
 
//    @Binding var isTeam : Bool
    @Binding var city : String
    @Binding var long : Double
    @Binding var lat : Double 
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(AppColor.lovolTan)
                  
              }
          }
      }
    
    var body: some View {
        GeometryReader{ geo in
            
            VStack{
                Spacer()
                HStack{
                    Text("Are you over 21?")
                        .font(.custom("Rubik Regular", size: 12))
                        .foregroundColor(.white)
                        .padding(10)
                    Spacer()
                }
                
                .padding(.leading,5)
                

         
                Spacer()
                Button {
                    
                } label: {
                    Text("Done")
                        .font(.custom("Rubik Bold", size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .frame(width:geo.size.width * 0.7)
                        .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolDarkerPurpleBackground))
                }
                Spacer()
            }
     
            
            
            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

            .background(BackgroundView())

            
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
        

            
            
        }
    }
            
            
        
}

struct EditLocationView_Previews: PreviewProvider {
    @State static var city : String = "San Jose"
    @State static var long : Double = 0
    @State static var lat : Double = 0

    static var previews: some View {
        EditLocationView(city: $city, long:$long,lat:$lat)
    }
}
