//
//  SubmitLovolsView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/26/22.
//

import SwiftUI

struct SubmitLovolsView: View {
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
    
    @EnvironmentObject private var eventViewModel  : EventViewModel
    @EnvironmentObject private var profileViewModel  : ProfilesViewModel

    @State private var totalTeamPoints : Int = 0
    @State private var totalTeamRaffles : Int = 0
    @State private var enteredPoints : Int = 0
    
    @State private var showDivisibleError : Bool = false
    @State private var showYouDontHaveThosePointsError : Bool = false
    @State private var showZeroError : Bool = false

    @State private var showError : Bool = false
    @State private var showGroupError : Bool = false
    @State private var showSubmitError : Bool = false
    @State private var loadingPoints : Bool = true
    @State private var loadingSubmit : Bool = false
    @State private var season : Int = 0
    
    @State private var groupId : String = ""
    
    var body: some View {
        
        NavigationStack{
            GeometryReader { geo in
                    if loadingPoints {
                        ProgressView()
                            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)
                    }else{
                       
                            ScrollView{
                                VStack(spacing:30){
                                Text("Total Team Lovols:")
                                        .padding(.top,10)
                                Text("\(totalTeamPoints)")
                                Text("Submit Lovols to increase your chance of qualifying for this month’s gameshow!")
                                    .frame(width:geo.size.width * 0.7)
                                Text("100 Lovol bits = 1 Lovol ")
                                TextField("Lovols", value: $enteredPoints, format: .number)
                                    .scrollContentBackground(.hidden) // <- Hide it
                                    .padding(.vertical,10)
                                    .background(AppColor.lovolTan)
                                    .foregroundColor(AppColor.lovolDarkPurple)
                                    .cornerRadius(20)
                                    .frame(width:geo.size.width * 0.2,height:geo.size.height * 0.1)
                                Button {
                                    submitPoints()
                                } label: {
                                    Text("Enter")
                                    
                                        .foregroundColor(AppColor.lovolDarkPurple)
                                        .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan).frame(width:geo.size.width * 0.2, height: 50).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                                }
                                .padding()
                                Text("Current Lovols in System:")
                                Text("\(totalTeamRaffles)")
                                
                                
                            }
                        }
                        .frame(width: geo.size.width * 0.95, height:geo.size.height * 0.98)                    .multilineTextAlignment(.center)
                        .font(.custom("Rubik Regular", size: 14))
                        .foregroundColor(AppColor.lovolTan)
                        .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolDarkPurple).shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4))
                                        .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

                        
                    }
                    
                    
                }
            .alert("There was an error retrieving information. Please try again.", isPresented: $showError, actions: {
                Button("OK", role: .cancel, action: {
                })
            })
            .alert("Please join or create a team.", isPresented: $showGroupError, actions: {
                Button("OK", role: .cancel, action: {
                })
            })
            .alert("There was an error submitting your points. Please try againn.", isPresented: $showSubmitError, actions: {
                Button("OK", role: .cancel, action: {
                })
            })
            .alert("Please enter a value greater than 0.", isPresented: $showZeroError, actions: {
                Button("OK", role: .cancel, action: {
                })
            })
            .alert("Please enter a value divisible by 100 ", isPresented: $showDivisibleError, actions: {
                Button("OK", role: .cancel, action: {
                })
            })
            .alert("Your team does not have enought lovols.", isPresented: $showYouDontHaveThosePointsError, actions: {
                Button("OK", role: .cancel, action: {
                })
            })

            }
            
            .frame(maxWidth:.infinity,maxHeight:.infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarTitle("")
            .toolbar {
               ToolbarItemGroup(placement: .principal) {
                   Text("Season \(season)")
                       .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)

               }
            }
            .showLoading(loadingSubmit)
            
            
            .onAppear(perform: fillInPoints)
            
            


       
    }
    
    
    private func fillInPoints(){
        
        profileViewModel.fetchUserWO { result in
            switch result {
            case .success(let user):
                groupId = user.groupId ?? ""

                if groupId == "" {
//                    showGroupError = true
                    loadingPoints = false 
                    return
                }
                else{
                    eventViewModel.fetchPoints(groupId: groupId) { result in
                        switch result{
                        case .success(let points):
                            self.totalTeamPoints = points.currentPoints
                            self.totalTeamRaffles = points.currentRaffles
                            self.season = points.season
                            loadingPoints = false
                        case .failure(let error):
                            print("Error fetching points \(error)")
                            showError = true
                            return
                        }
                    }
                }
            case .failure(let error):
                print("Error fetching points \(error)")
                showError = true
                return
            }
        }
        
        
    }
    private func submitPoints(){
        loadingSubmit = true
        if groupId == "" {
            showGroupError = true
            loadingPoints = false

            return
        }
        else if enteredPoints == 0 {
            
            showZeroError = true
            loadingSubmit = false

            return
        }
        else if enteredPoints % 100 != 0 {
            showDivisibleError = true
            loadingSubmit = false

            return
        }
        
        eventViewModel.submitPoints(groupId: groupId, points: enteredPoints) { result in
            switch result{
            case .success(true):
                self.totalTeamPoints -= enteredPoints
                self.totalTeamRaffles += (enteredPoints/100)
                self.enteredPoints = 0
                loadingSubmit = false
                return
            case .success(false):
                showYouDontHaveThosePointsError = true
                loadingSubmit = false
                

                return
            case .failure(let error):
                showSubmitError = true
                loadingSubmit = false

                print("error submitting points \(error)")
                return
            }
        }

    



    }
}

struct SubmitLovolsView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitLovolsView()
    }
}
