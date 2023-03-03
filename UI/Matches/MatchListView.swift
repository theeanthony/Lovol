//
//  MatchListView.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/21/22.
//

import SwiftUI

struct MatchListView: View {
    @EnvironmentObject var firestoreViewModel: FirestoreViewModel
    @EnvironmentObject var profileViewModel : ProfilesViewModel
    @State private var loading = true
    @State private var matches: [MatchModel] = []
    @State private var groupMatches : [MatchModel] = []
    @State private var groupId : String = ""
    @State private var groupMatchModel : MatchModel = MatchModel(id: "", userId: "", name: "", birthDate: Date(), picture: UIImage(), lastMessage: "", isGroup: true)
    @State private var queue: [MatchModel] = []
    @State private var teamName : String = ""
//    @State private var queue: [MatchModel] = []
    @State private var matchSheet : Bool = false 
    var body: some View {
        NavigationStack{
            GeometryReader { geo in
                VStack{
                    Spacer()
                    if(loading){
                        ProgressView()
                            .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)

                    }else {
                        VStack{
//                            VStack(spacing:5){
//                                HStack{
//                                    Text("Match Queue:")
//                                        .font(.custom("Rubik Bold", size: 14))
//                                        .foregroundColor(AppColor.lovolDarkPurple)
//                                    //                                .padding(.top,10)
//                                        .padding(.leading,10)
//
//                                    Spacer()
//                                }
////                                .frame(height: geo.size.height * 0.1)
//
//                                ScrollView(.horizontal){
//                                    if !queue.isEmpty{
//                                        HStack{
//                                            ForEach(queue.indices, id: \.self){
//                                                index in
//                                                NavigationLink(destination: ChatView(match: queue[index],groupConvo:false)){
//                                                    MatchQueueView(model: queue[index])
//                                                        .padding(.trailing,5)
//                                                }
//                                            }
//
//                                        }
//                                        //                                .padding(.bottom,10)
//                                        .padding(.horizontal,10)
//                                    }
//                                    else{
//                                        Text("No Matches")
//                                            .font(.custom("Rubik Bold", size: 14))
//                                            .foregroundColor(AppColor.lovolDarkPurple)
//                                            .padding(.leading,10)
//                                        Spacer()
//
//
//                                    }
//
//
//                                    //                                .padding(.bottom,10)
//                                    //
//                                }
//                                .frame(width:geo.size.width * 0.9)
//
//                            }
//                            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan).frame(width: geo.size.width * 0.9))
//                            .padding(.horizontal,20)
//                                                    Spacer()
                            VStack{
                                HStack{
                                    Text("Conversations:")
                                        .font(.custom("Rubik Bold", size: 14))
                                        .foregroundColor(AppColor.lovolDarkPurple)
                                    Spacer()
                                }
                                .padding(.leading,15)
                                
                                ScrollView{
                                    if groupId != "" {
                                        NavigationLink(destination: ChatView(match: groupMatchModel, groupConvo: true)){
                                            MatchItemView(model: groupMatchModel)
                                        }
                                    }
                                    if(matches.isEmpty && groupMatches.isEmpty && groupId.isEmpty){
                                        Text("No Messages")
                                            .font(.custom("Rubik Bold", size: 14))
                                            .foregroundColor(AppColor.lovolDarkPurple)
                                    }
                                    
                                    else if (groupMatches.isEmpty && matches.count > 0){
                                        
                                        ForEach(matches.indices, id: \.self) {
                                            index in
                                            NavigationLink(destination: ChatView(match:matches[index],groupConvo: false)){
                                                MatchItemView(model: matches[index])
                                            }
                                        }
                                        
                                    } else if (groupMatches.count > 0 && matches.isEmpty){
                                        ForEach(groupMatches.indices, id: \.self) {
                                            index in
                                            NavigationLink(destination: ChatView(match:groupMatches[index],groupConvo: false)){
                                                MatchItemView(model: groupMatches[index])
                                                    .padding(5)
                                                
                                            }
                                            
                                        }
                                    }else{
                                        ForEach(matches.indices, id: \.self) {
                                            index in
                                            NavigationLink(destination: ChatView(match:matches[index],groupConvo: false)){
                                                MatchItemView(model: matches[index])
                                                    .padding(5)
                                                
                                            }
                                            
                                        }
                                        ForEach(groupMatches.indices, id: \.self) {
                                            index in
                                            NavigationLink(destination: ChatView(match:groupMatches[index],groupConvo: false)){
                                                MatchItemView(model: groupMatches[index])
                                                    .padding(5)
                                                
                                            }
                                            
                                        }
                                        
                                    }
                 

                                }
                                .frame(width:geo.size.width * 0.9, height:geo.size.height * 0.85)
                                Button {
                                    matchSheet.toggle()
                                } label: {
                                    Text("Check Match Queue")
                                        .font(.custom("Rubik Bold", size: 14))
                                        .foregroundColor(AppColor.lovolDarkPurple)
                                }
                                
                            }
                            .frame(width:geo.size.width * 0.9 ,height:geo.size.height * 0.95)
                            .background(RoundedRectangle(cornerRadius: 20).fill(AppColor.lovolTan))
                            .padding(.horizontal,20)
                            .padding(.bottom,15)
                            
                        }
                        .position(x:UIScreen.main.bounds.width/2,y: geo.size.height / 2)
                    }
                    

                    
                }
                .navigationBarTitle("")
                .toolbar {
                    ToolbarItemGroup(placement: .principal) {
                        Text("Messages")
                            .font(.custom("Rubik Regular", size: 20)).foregroundColor(AppColor.lovolTan)
                        
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                
                .frame(maxWidth:.infinity,maxHeight:.infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [AppColor.lovolPinkish, AppColor.lovolOrange]), startPoint: .top, endPoint: .bottom)
                )
                            .onAppear(perform: performOnAppear)
                .sheet(isPresented: $matchSheet) {
                    QueueSheetView(queue: queue)
                        .presentationDetents([.medium, .large])
//                        .presentationDragIndicator(.hidden)
                    

                }
            }
            
            
            
        }
    }
    
    private func onReceiveMatches(result: Result<[MatchModel], DomainError>){
        switch result{
        case .success(let fetchedMatches):
            

            var regularMatches : [MatchModel] = []
            var queueMatches: [MatchModel] = []
            for index in fetchedMatches.indices {
                print("index \(index)")
                if fetchedMatches[index].lastMessage == nil {
                    print(fetchedMatches[index].lastMessage ?? "this message is nil")
                    queueMatches.append(fetchedMatches[index])
                    print("removed fetchmatch to enter queue")
//                    fetchedMatches.remove(at: index)
                    

                }
                else{
                    regularMatches.append(fetchedMatches[index])
                }
            }

            

            
            
            self.matches = regularMatches
            self.queue = queueMatches
            loading = false
            return
        case .failure(_):
            print("error on receive matches")
            return
        }
    }
//    private func onReceiveGroupMatches(result: Result<[MatchModel], DomainError>){
//        loading = false
//        switch result{
//        case .success(let matches):
//            self.groupMatches = matches
//            return
//        case .failure(_):
//            return
//        }
//    }
    

    private func performOnAppear(){
        print("loading \(loading)")
        profileViewModel.fetchUserWO(onCompletion: { result in
            switch result {
            case .success(let user):
                
                self.groupId = user.groupId ?? ""
                if groupId != "" {
                    print(groupId)
                    profileViewModel.fetchOwnGroupConvo(id: groupId) { result in
                        switch result {
                        case .success(let model):
                            self.groupMatchModel = model
                           
                            print(model)
                        case .failure(let error):
                            print("error retrieving group convo \(error)")

                        }
                    }
                }
                firestoreViewModel.fetchGroupAndUserMatches(groupId: groupId,onCompletion: onReceiveMatches)
                
          
        case .failure(let error):
                print("Error fetching user in matchlistview \(error)")

            }
        })
    }
}

struct MatchListView_Previews: PreviewProvider {
    static var matches: [MatchModel] = [MatchModel(id: "0", userId: "0", name: "Anthony", birthDate: Date(), picture: UIImage(named: "elon_musk")!, lastMessage: "hello", isGroup: true),MatchModel(id: "0", userId: "0", name: "Jeff", birthDate: Date(), picture: UIImage(named: "elon_musk")!, lastMessage: "hello", isGroup: true)]
    static var groupMatches: [MatchModel] =  [MatchModel(id: "0", userId: "0", name: "Angle", birthDate: Date(), picture: UIImage(named: "elon_musk")!, lastMessage: "hello", isGroup: false),MatchModel(id: "0", userId: "0", name: "Butter", birthDate: Date(), picture: UIImage(named: "elon_musk")!, lastMessage: "hello", isGroup: false)]
    static var groupMatchModel : MatchModel = MatchModel(id: "1", userId: "2", name: "Squad 1", birthDate: Date(), picture: UIImage(named: "elon_musk")!, lastMessage: "yo", isGroup: true)
    static var previews: some View {
        MatchListView()
            .environmentObject(FirestoreViewModel())
    }
}


