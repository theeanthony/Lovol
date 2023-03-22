//
//  ReportSheetView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/20/22.
//

import SwiftUI

struct ReportSheetView: View {
    var reportId : String
    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var reportReasons : [String] = ["Bot Account", "Nudity Or Sexual Activity", "Hate Speech Or Symbols", "Suicide or Self-Injury", "Sale of illegal or regulated goods"]
    var body: some View {
        VStack{
            Spacer()
            
            Text("Please choose the reason why this account is being reported.")
                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

                .frame(width:250)
            
            VStack{
                
                ForEach (reportReasons.indices, id: \.self){
                    index in
                    Button {
                        report(reason: reportReasons[index])
                    } label: {
                        HStack{
                            Spacer()
                            Text(reportReasons[index])
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(.trailing,15)
                    }.padding()

                    
                }
                
                
            }
            Spacer()
            
        }
        .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white)
        .background(AppColor.lovolDark)
       
    }
    private func report(reason: String){
     
        print("REPort reason goin in \(reason)")
        let reportSheet : ReportModel = ReportModel(reason: [reason], description: "", timesReported: 1)
        firestoreViewModel.reportUser(id: reportId, reportSheet: reportSheet)
        presentationMode.wrappedValue.dismiss()
        
    }
}

struct ReportSheetView_Previews: PreviewProvider {
    
    static var previews: some View {
        ReportSheetView(reportId: "")
    }
}
