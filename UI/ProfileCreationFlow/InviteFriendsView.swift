//
//  FinishProfileView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/18/23.
//

import SwiftUI

struct InviteFriendsView: View {
    @EnvironmentObject private var profileViewModel : ProfilesViewModel
    @EnvironmentObject private var authViewModel : AuthViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var btnBack : some View { Button(action: {
          self.presentationMode.wrappedValue.dismiss()
          }) {
              HStack {
                  Image(systemName: "chevron.left") // set image here
                  .aspectRatio(contentMode: .fit)
                  .foregroundColor(.white)
                  
              }
          }
      }

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
    
    @State private var phoneContacts = [PhoneContact]() // array of PhoneContact(It is model find it below)
    @State private var searchContacts = [PhoneContact]()
    @State private var phoneDictionary : [String:PhoneContact] = [:]
      var filter: ContactsFilter = .none
    @State private var isLoading : Bool = true
    @State private var searchFilter : String = ""
    
    @State private var selectedContacts = [PhoneContact]()
    
    

    var searchResults: [PhoneContact] {
        
        if searchFilter.count == 0 {
            return phoneContacts.sorted { leftContact, rightContact in
                leftContact.name! < rightContact.name!
            }
        }

        return phoneContacts.filter {$0.name!.lowercased().contains(searchFilter.lowercased())}


    }

    var body: some View {
        VStack{
            Spacer()
            if isLoading {
                ProgressView()
            }else{
                VStack{
                    SearchBar(text: $searchFilter)
                    Spacer()
                    List{
                            ForEach(searchResults,id:\.self){
                                contact in
//                                    if contact.name == "" {
//                                        print("empty contact name")
//                                    }
                                Button {
                                    contact.isSelected.toggle()
                                    if contact.isSelected{
                                  
                                        phoneDictionary[contact.name!] = contact
                                        selectedContacts.append(contact)
                                    }else{
                                        phoneDictionary.removeValue(forKey: contact.name!)
                                        
                                    }
                                } label: {
                                    VStack{
//                                            Text(contact.phoneNumber[0])
//                                                .font(.custom("Rubik Regular", size: 10)).foregroundColor(.white)
                                        HStack{
                                  
                                            Text("\(contact.name ?? contact.phoneNumber[0])")
                                                .listRowBackground(AppColor.lovolDarkerPurpleBackground)
                                            
                                                .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                                            
                                            Spacer()
                                            
                                            
                            
                                            
                                            
                                        }
                                    }

                                }

                                
                                
                            }
             

                    }
                    .scrollContentBackground(.hidden)
//                        .frame(width:geo.size.width , height:geo.size.height * 0.95)
                    
                    .padding(.bottom,10)
                    ScrollView(.horizontal){
                        HStack{

                            ForEach(selectedContacts.indices,id:\.self){ contact in
                            
                            Button {
                                selectedContacts.remove(at: contact)
                            } label: {
                                Text(selectedContacts[contact].name!)
                                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)
                            }

                            }
                        }
                        .padding(.horizontal)
                 
                    }
                    .scrollIndicators(.hidden
                    )
                    if !selectedContacts.isEmpty {
                        Button {
                            
                        } label: {
                            Text("Send Invite")
                                .font(.custom("Rubik Bold", size: 14)).foregroundColor(.white)

                                .padding()
                                .padding(.horizontal,40)
                                .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolDarkerPurpleBackground))
                        }
                        .padding()

                    }
                }
            }
            Spacer()
        }
        
//        }
        .toolbar(.hidden,for:.tabBar)
        .background(AppColor.lovolDark)

    .navigationBarBackButtonHidden(true)
    .navigationBarItems(leading: btnBack)
    .navigationBarTitleDisplayMode(.inline)
    
    .onAppear(perform: onAppear)
    
}
func onAppear(){
    
//        self.numbers = phoneNumberWithContryCode()
    
    retrievePhoneContact()
    isLoading = false

    
}

func retrievePhoneContact() {
//        let contacts = PhoneContacts.getContacts() // here calling the getContacts methods
    
    phoneContacts.removeAll()
    var count = 0

    for contact in PhoneContacts.getContacts(filter: filter) {
        
        
        self.phoneContacts.append(PhoneContact(contact: contact))
//            phoneDictionary[count] = false
        
        count += 1
    }
    
    phoneContacts = phoneContacts.filter({$0.name != ""})
    self.searchContacts = phoneContacts.sorted { leftContact, rightContact in
        leftContact.name! < rightContact.name!
    }
//        for contact in phoneContacts {
//          print("Name -> \(contact.name)")
//          print("Email -> \(contact.email)")
//          print("Phone Number -> \(contact.phoneNumber)")
//        }
    
}
}

//struct FinishProfileView_Previews: PreviewProvider {
//
//    @State static var teamModel : TeamModel = TeamModel(teamName: "", teamDescription: "", teamRule: false,city:"",long:0,lat:0)
//    static var previews: some View {
//        FinishProfileView(name: "", role: "", pic: UIImage(), age: false, teamInfo: $teamModel, teamPic: UIImage(), teamCreatedOption: false)
//    }
//}
