//
//  EventExclusivity.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/20/23.
//

import SwiftUI

struct EventExclusivity: View {
    
    @Binding var exclusivity : Int
    @State private var allianceOnlyQuestionSheet : Bool = false
    @State private var alliancePlusQuestionSheet : Bool = false
    @State private var publicQuestionSheet : Bool = false

    var body: some View {
        VStack{
            
            
            HStack{
                Button {
                    self.exclusivity = 0
                } label: {
                    Text("Alliances only")
                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

                        .padding()
                        .frame(width:200)
                        .background(RoundedRectangle(cornerRadius:30).fill(exclusivity == 0 ? AppColor.lovolOrange : AppColor.lovolDarkerPurpleBackground))
                }
                Button {
                    allianceOnlyQuestionSheet.toggle()
                } label: {
                    Image(systemName:"questionmark.circle.fill").foregroundColor(.white)
                }

            }
            .padding(.vertical)
            HStack{
                
            Button {
                self.exclusivity = 1

            } label: {
                Text("Alliances and Alliances of Alliances")
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

                    .padding()
                    .frame(width:200)

                    .background(RoundedRectangle(cornerRadius:30).fill(exclusivity == 1 ? AppColor.lovolOrange : AppColor.lovolDarkerPurpleBackground))
                }
                Button {
                    alliancePlusQuestionSheet.toggle()
                } label: {
                    Image(systemName:"questionmark.circle.fill").foregroundColor(.white)
                }
            }
            .padding(.vertical)

            HStack{
                Button {
                    self.exclusivity = 2
                    
                } label: {
                    Text("Public")
                        .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

                        .padding()
                        .frame(width:200)
                    
                        .background(RoundedRectangle(cornerRadius:30).fill(exclusivity == 2 ? AppColor.lovolOrange : AppColor.lovolDarkerPurpleBackground))
                }
                Button {
                    publicQuestionSheet.toggle()
                } label: {
                    Image(systemName:"questionmark.circle.fill").foregroundColor(.white)
                }
            }
            .padding(.vertical)

            
            
        }
        .sheet(isPresented: $allianceOnlyQuestionSheet) {
            AllianceOnly()
                .presentationDetents([ .medium])
                    .presentationDragIndicator(.hidden)
            

        }
        .sheet(isPresented: $alliancePlusQuestionSheet) {
            AlliancePlusSheet()
                .presentationDetents([ .medium])
                    .presentationDragIndicator(.hidden)
            

        }
        .sheet(isPresented: $publicQuestionSheet) {
            PublicSheet()
                .presentationDetents([ .medium])
                    .presentationDragIndicator(.hidden)
            

        }
    }
}

//struct EventExclusivity_Previews: PreviewProvider {
//    static var previews: some View {
//        EventExclusivity()
//    }
//}
