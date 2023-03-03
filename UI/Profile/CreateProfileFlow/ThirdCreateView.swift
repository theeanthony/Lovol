//
//  ThirdCreateView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/6/22.
//

import SwiftUI

struct ThirdCreateView: View {
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
    var count: Int
    var questions: [String]
    var name: String
    var pronouns : String
    var bio : String
    @State var birthDate : Date = Date()

    
    @State var month : String = ""
    @State var day : String = ""
    @State var year : String = ""
    @State private var monthDayLimit : Int = 2
    @State private var yearLimit : Int = 4


    var partialRange: PartialRangeThrough<Date>{
        let eighteenYearsAgo = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
        return ...eighteenYearsAgo
    }
    
 

    var body: some View {
        NavigationStack{
            GeometryReader {geo in
                VStack{
                        VStack{
                            HStack{
                                TextField("", text: $month, axis:.vertical).placeholder(when: month.isEmpty) {
                                    Text("XX")
                                }.onChange(of: month, perform: {newValue in
                                    if(newValue.count >= monthDayLimit){
                                        month = String(newValue.prefix(monthDayLimit))
                                    }
                                })
                                .scrollContentBackground(.hidden) // <- Hide it
                                //                                .padding(.vertical,10)
                                .padding()
                                .frame(width:geo.size.width * 0.25 , height: 90)
                                
                                .background(AppColor.lovolTan)                                .cornerRadius(20)
                                .lineLimit(1)

                                .opacity(0.8)
                                .foregroundColor(AppColor.lovolDarkPurple)
                                Text("/")
                                    .foregroundColor(AppColor.lovolTan)
                                
                                TextField("", text: $day, axis:.vertical).placeholder(when: day.isEmpty) {
                                    Text("XX")
                                }.onChange(of: day, perform: {newValue in
                                    if(newValue.count >= monthDayLimit){
                                        day = String(newValue.prefix(monthDayLimit))
                                    }
                                })
                                .scrollContentBackground(.hidden) // <- Hide it
                                .padding()
                                .frame(width:geo.size.width * 0.25 , height: 90)
                                .lineLimit(1)

                                .background(AppColor.lovolTan)                                .cornerRadius(20)
                                
                                .opacity(0.8)
                                
                                .foregroundColor(AppColor.lovolDarkPurple)
                                Text("/")
                                    .foregroundColor(AppColor.lovolTan)
                                
                                TextField("", text: $year, axis:.vertical).placeholder(when: year.isEmpty) {
                                    Text("XXXX")
                                }.onChange(of: year, perform: {newValue in
                                    if(newValue.count >= monthDayLimit){
                                        year = String(newValue.prefix(yearLimit))
                                    }
                                })
                                .scrollContentBackground(.hidden) // <- Hide it
                                .padding()
                                .frame(width:geo.size.width * 0.25 , height: 90)
                                .lineLimit(1)
                                .background(AppColor.lovolTan)
                                .cornerRadius(20)
                                .opacity(0.8)
                                .foregroundColor(AppColor.lovolDarkPurple)
   
                            }
                            
//                            Spacer()
                            Button(action:{
                            }, label: {
                                NavigationLink(destination: CollegeCreateView(count: count + 1, questions: questions, name: name, pronouns: pronouns, bio: bio, birthDate: birthDate)) {
                                    
                                    Image(systemName:"arrow.right")
                                        .centerCropped()
                                        .frame(width: 50, height: 40)
                                        .foregroundColor(checkBirthDate() ? AppColor.lovolTan : AppColor.lovolTan.opacity(0.5))
                                    
                                    
                                }
                            })
                            .padding(.top,50)
                            .disabled(!checkBirthDate())
                            .frame(height:geo.size.height * 0.25)
                            
                        }
                        .font(.custom("Rubik Regular", size: 14))
                        .foregroundColor(AppColor.lovolDarkPurple)
                        .padding(.top,10)
                        .multilineTextAlignment(.center)
                        .frame(width: geo.size.width * 0.9, height: 250)
                        //                    .background(RoundedRectangle(cornerRadius:20).fill(AppColor.lovolTan))
                        .padding(.horizontal,20)
                        

                    }
//                .frame(height:geo.size.height * 0.5)
//                }
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 3)

                }
                
                .frame(maxWidth:.infinity,maxHeight:.infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
                )
                .navigationBarTitle("")
                .toolbar {
                   ToolbarItemGroup(placement: .principal) {
                       Text("Choose Birthday")
                           .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

                   }
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: btnBack)
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea(.keyboard)
        }
    }

    private func checkBirthDate() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let startString = "03-06-1940"
        let endString = "03-06-2020"
        let startDate = dateFormatter.date(from:startString)!

        let endDate = dateFormatter.date(from:endString)!

        if let date = dateFormatter.date(from:"\(month)-\(day)-\(year)") {
            
            if  (startDate ... endDate).contains(date){
                self.birthDate = date
                return true
            }
            else{
                return false

            }
        }
        else {
           return false
        }
        
        
    }
}


struct ThirdCreateView_Previews: PreviewProvider {
    static let questions : [String] = ["Name", "Bio"]
    static var previews: some View {
        ThirdCreateView(count: 1, questions: questions, name: "Anthony", pronouns: "", bio: "")
    }
}

extension Date {
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}
