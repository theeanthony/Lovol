//
//  FinishProfileView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/18/23.
//

import SwiftUI
import ContactsUI
struct FinishProfileView: View {
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @EnvironmentObject private var firestoreViewModel : FirestoreViewModel
    @EnvironmentObject private var authViewModel : AuthViewModel
    

    @State private var tips : [String] = ["You can exchange 100 lovol bits for one lovol","If you are a team of 6, your points get multiplied times 2!", "When team swipe is on, the team member who activated it has control.","Make sure to have everyone in your team in the picture for it to count!", "Quality over quantity", "Make sure to have everyone grouped around for team swiping!", "Does a team's event submission look sus? Downvote it."]
    @State private var index : Int = 0

    @State private var doneUploading : Bool = false
    @State private var uploading : Bool = false
    
    let joinGroupId:String
    let name : String
    let role : String
    let pic : UIImage
    let age : Bool
    @Binding var teamInfo : TeamModel
    let teamPic : UIImage
    let teamCreatedOption : Bool
    @State private var urlString : URL = URL(string: "https://lovolac.com")!

    @State private var authorized : Bool = false
    // yourteam has blank spots, invite morepeople
    //invite friends for newly created group
    
    @State private var contactClicked = false
    @State private var isPresented : Bool = false
    
    @State private var enableContactsInSettings : Bool = false 
    var body: some View {
        VStack{
            
//                Spacer()
            

       
//                Spacer()
      
              
         
            GeometryReader{ geo in
                VStack(spacing: 20){

                    
                    
                    if !uploading{
                        
//                        if joinGroupId != "" || teamCreatedOption {
//
                        Spacer()
                            HStack{

                                Spacer()
                                ShareLink(teamCreatedOption ? "Drop this link in your main group chat to have them join your team!" : "Drop this link in your main group chat so they can join you!", item: urlString)
                                    .font(.custom("Rubik Bold", size: 18)).foregroundColor(.white).multilineTextAlignment(.center)
                                
                                                                        

                                //                                Button {
////                             share()
//                                } label: {
//                                    Text("Invite Close Friends")
//                                        .font(.custom("Rubik Bold", size: 22)).foregroundColor(.white)
//                                    Spacer()
//                                    Image(systemName:"arrow.right").foregroundColor(.white)
//                                }
////  \
                                Spacer()
                                }
                        Spacer()
//
//
//                            }
//                            .padding()
//                            .padding(.vertical,30)
//                        }
                 
                        Button {
                            submit()
                        } label: {
                            Text( "Ready").padding().frame(width:geo.size.width * 0.7).background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolPinkish))                            .font(.custom("Rubik Bold", size: 22)).foregroundColor(.white)

                        }
                        Spacer()

                    }else{
                        
                        ProgressView()
                        Text("Tips:")
                            .font(.custom("Rubik Bold", size: 20))
                            .foregroundColor(.white)

          
                        Text(tips[index])
                                .font(.custom("Rubik Regular", size: 18))
                                .foregroundColor(.white)
                                .frame(width: geo.size.width * 0.8)
                                .multilineTextAlignment(.center)
                                .frame(width:geo.size.width * 0.8, height: geo.size.height * 0.1)
                    }
                  
       

         
                 

                }
                .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)


            }
                
 

        }
        .navigationBarBackButtonHidden(true)

        .frame(maxWidth:.infinity,maxHeight:.infinity)
        .background(AppColor.lovolDark)

        .sheet(isPresented: $enableContactsInSettings) {
            EnableContactsInSettingsSheet()
                .presentationDetents([.medium])
        }
        .onAppear(perform: onAppear)
        
    }
    private func onAppear(){
        firestoreViewModel.shareTapped(joinGroupId) { url in
            self.urlString = url
        }
    }

    private func checkContact(){
        print("checking")
            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .notDetermined:
                let filter : ContactsFilter = .none
                for _ in PhoneContacts.getContacts(filter: filter) {
                    break

                }
            case .authorized:
                self.authorized = true
                print("authorized")
                isPresented = true
            case .denied:
                
                enableContactsInSettings = true
                return
            default: return
            }
        }
    
    private func submit(){
        
        uploading = true
        performOnAppear()
        
        profileViewModel.createUser(name: name, role: role, pic:pic, age:age) { result in
            switch result {
            case .success(()):
                if teamCreatedOption {
                    profileViewModel.createTeam(info: teamInfo, name: name, role:role, teamPic: teamPic, id:joinGroupId) { result in
                        switch result {
                        case .success(()):
                            self.authViewModel.signIn()
                            doneUploading = true

                        case .failure(let error):
                            print("error uploading group pic \(error)")
                            return
                        }
             
                    }
                }else{
                    self.authViewModel.signIn()
                    doneUploading = true
                }
            case .failure(let error):
                print("error uploading user pic \(error)")
                return
            }
        }
        

      
        
        
    }
    private func performOnAppear(){
        self.index = tips.startIndex

        _ = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            
            self.index = tips.index(after: index)
            if index == tips.endIndex  { self.index = 0 }
          }
           
  
        }
}

//struct FinishProfileView_Previews: PreviewProvider {
//    
//    @State static var teamModel : TeamModel = TeamModel(teamName: "", teamDescription: "", teamRule: false,city:"",long:0,lat:0)
//    static var previews: some View {
//        FinishProfileView(name: "", role: "", pic: UIImage(), age: false, teamInfo: $teamModel, teamPic: UIImage(), teamCreatedOption: false)
//    }
//}
