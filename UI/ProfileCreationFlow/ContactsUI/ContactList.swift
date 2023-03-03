//
//  ContactList.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/11/23.
//

import SwiftUI
import ContactsUI


struct ContactList: View {
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
    @State private var phoneContacts = [PhoneContact]() // array of PhoneContact(It is model find it below)
    @State private var searchContacts = [PhoneContact]()
    @State private var phoneDictionary : [String:PhoneContact] = [:]
      var filter: ContactsFilter = .none
    @State private var isLoading : Bool = true
    @State private var searchFilter : String = ""
    
    @State private var selectedContacts = [PhoneContact]()
    
    let isAccountCreated : Bool 
    

    var searchResults: [PhoneContact] {
        
        if searchFilter.count == 0 {
            return phoneContacts.sorted { leftContact, rightContact in
                leftContact.name! < rightContact.name!
            }
        }

        return phoneContacts.filter {$0.name!.lowercased().contains(searchFilter.lowercased())}


    }

    var body: some View {
//        GeometryReader{geo in
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
                                    if contact.name! != " "{
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
                                                .listRowBackground(AppColor.lovolDarkerPurpleBackground)
                                                HStack{
                                          
                                                    ForEach(contact.phoneNumber.indices , id:\.self){
                                                        index in
                                                        Text("\(contact.phoneNumber[index])")
                                                    }
                                                    
                                                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white).opacity(0.8)
                                                    
                                                    Spacer()
                                                    
                                                    
                                    
                                                    
                                                    
                                                }
                                                HStack{
                                          
                                                    ForEach(contact.email.indices , id:\.self){
                                                        index in
                                                        Text("\(contact.email[index])")
                                                    }
                                                    
                                                        .font(.custom("Rubik Regular", size: 12)).foregroundColor(.white).opacity(0.8)
                                                    
                                                    Spacer()
                                                    
                                                    
                                    
                                                    
                                                    
                                                }
                                            }
                                            .listRowBackground(AppColor.lovolDarkerPurpleBackground)


                                        }
                                        .listRowBackground(AppColor.lovolDarkerPurpleBackground)
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
//                        if !selectedContacts.isEmpty {
                            Button {
                                finished()
                            } label: {
                                Text(selectedContacts.isEmpty ? "Done" : "Send Invite")
                                    .font(.custom("Rubik Bold", size: 22)).foregroundColor(.white)

                                    .padding()
                                    .padding(.horizontal,40)
                                    .background(RoundedRectangle(cornerRadius: 30).fill(AppColor.lovolDarkerPurpleBackground))
                            }
                            .padding()

//                        }
                    }
                }
                Spacer()
            }
            
//        }
            .toolbar(.hidden,for:.tabBar)
        .background(
            LinearGradient(gradient: Gradient(colors: isAccountCreated ? [AppColor.lovolPinkish, AppColor.lovolOrange] : [AppColor.lovolDarkPurple, AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
         
           
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar{
            ToolbarItemGroup(placement:.principal){
                
                
                Text("Invite Friends")
                    .font(.custom("Rubik Regular", size: 14)).foregroundColor(.white)

            }
        }
        
        .onAppear(perform: onAppear)
        
    }
    func finished(){
        if selectedContacts.isEmpty{
            presentationMode.wrappedValue.dismiss()
        }
        else{
            
            var filteredContacts : [String] = []
            
            for selectedContact in selectedContacts {
                var phoneNumber = selectedContact.phoneNumber.count
                if phoneNumber == 0 {
                    continue
                }else{
                    var phoneNumberString = selectedContact.phoneNumber[0]
                    var newNumber : String = ""
                    for numbers in phoneNumberString.indices {
                        if phoneNumberString[numbers] == " " || phoneNumberString[numbers] == "(" || phoneNumberString[numbers] == ")" || phoneNumberString[numbers] == "-" || phoneNumberString[numbers] == "+" {
                            continue
                            
                        }else{
                            newNumber.append(phoneNumberString[numbers])
                        }
                    }
                    if newNumber.count == 10 {
                        newNumber = "1"+newNumber
                        filteredContacts.append(newNumber)

                    }else{
                        filteredContacts.append(newNumber)
                    }
                    print(newNumber)
                    
                    
                }
            }
            
            presentationMode.wrappedValue.dismiss()

        }
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
        phoneContacts.removeDuplicates()
        self.searchContacts = phoneContacts.sorted { leftContact, rightContact in
            leftContact.name! < rightContact.name!
        }
//        for contact in phoneContacts {
//          print("Name -> \(contact.name)")
//          print("Email -> \(contact.email)")
//          print("Phone Number -> \(contact.phoneNumber)")
//        }
        
    }
//    func phoneNumberWithContryCode() -> [String] {
//
//        let contacts = PhoneContacts.getContacts() // here calling the getContacts methods
//        var arrPhoneNumbers = [String]()
//        for contact in contacts {
//            for ContctNumVar: CNLabeledValue in contact.phoneNumbers {
//                if let fulMobNumVar  = ContctNumVar.value as? CNPhoneNumber {
//                    //let countryCode = fulMobNumVar.value(forKey: "countryCode") get country code
//                       if let MccNamVar = fulMobNumVar.value(forKey: "digits") as? String {
//                            arrPhoneNumbers.append(MccNamVar)
//                    }
//                }
//            }
//        }
//
//        return arrPhoneNumbers // here array has all contact numbers.
//    }
}

//struct ContactList_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactList(teamCreated : true )
//    }
//}
