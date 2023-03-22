//
//  RequestsViewModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/6/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import CoreData
import simd
import FirebaseStorage

class RequestViewModel: NSObject, ObservableObject{
    private let viewContext = PersistenceController.shared.container.viewContext
    private let firestoreViewModel = FirestoreViewModel()
    private let profileViewodel = ProfilesViewModel()
    private let db = Firestore.firestore()
    private var userId: String? {
        Auth.auth().currentUser?.uid
        
    }
    
    
    //this first checks to see if the group is full, if it is returns false then group is full, returns true then request sent
    func sendRequest(groupId: String, onCompletion:@escaping (Result<Bool,DomainError>)->()){
        
        if(groupId.count != 10){
            onCompletion(.failure(.parsingError))
            return
        }
        
        let groupRef = db.collection("group_v2").document(groupId)
        groupRef.getDocument { document, error in
            guard error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if let document = document, document.exists {
                self.firestoreViewModel.fetchGroupProfile(groupId: groupId) { result in
                    switch result{
                    case .success(let group):
                        let groupCount = group.teamMemberIDS.count
                        if groupCount == 6 {
                            onCompletion(.success(false))
                            return 
                        }
                        else{
                            let groupId = group.id
                            self.profileViewodel.fetchMember { result in
                                switch result {
                                case .success(let localUser):
                                    let sendingName = localUser.name
                                    let sendingId = self.userId!
                                    let sendRole = localUser.role
                                    let fireRequest = FirestoreRequest(groupId: groupId , sendingRequestId: sendingId, nameOfSender: sendingName, sendRole: sendRole, isFriends: false)
                                    self.db.collection("requests_v1").document(sendingId).setData(fireRequest.dictionary)
                                    onCompletion(.success(true))
                                    return
                                case .failure(let error):
                                    onCompletion(.failure(error))
                                    return
                                }
                            }
                    
                        }
                    case .failure(let error):
                        print("error fetching group profile still \(error)")
                        onCompletion(.failure(error))
                        return
                    }
                    
                }
                
                
            }
            else{
                print("error sending request from request model")
                onCompletion(.failure(.downloadError))
                return
            }
            
        }
    }
    func canISendRequest(groupId: String, onCompletion:@escaping (Result<Bool,DomainError>)->()){
        
        let reqRef = db.collection("requests_v1").document(userId!)
        reqRef.getDocument { doc, error in
            guard error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if let doc = doc , doc.exists {
                onCompletion(.success(false))
                return
            }
            else {
                onCompletion(.success(true))
                return
            }
        }
        
    }
    //cancels request client side
    func cancelRequest(onCompletion:@escaping () -> () ){
        db.collection("requests_v1").document(userId!).delete()
        onCompletion()
        
    }
    func cancelRequest(id: String, onCompletion:@escaping () -> () ){
        db.collection("requests_v1").document(id).delete()
        onCompletion()
        
    }
    
    //fetches requests sent to group
    func fetchRequestsForGroup(groupId: String, onCompletion:@escaping(Result<[RequestModel],DomainError>)->()){
        db.collection("requests_v1").whereField("groupId",isEqualTo: groupId).whereField("isFriends",isEqualTo: false).getDocuments{ documents, error in
            guard let documents = documents , error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            var requestList: [RequestModel] = []
            if documents.documents.count == 0 {
                onCompletion(.success([]))
                return
            }
            let maxCount = documents.documents.count
            var count = 0
            for docs in documents.documents{
                
                let requestName = docs.get("nameOfSender") as! String
                let requestId = docs.get("sendingRequestId") as! String
                let requestRole = docs.get("sendRole") as! String
                let isATeam = docs.get("isATeam") as! Bool

                
                let requestModel = RequestModel(id: docs.documentID, sendingRequestId: requestId, nameOfSender: requestName, groupId: groupId, sendRole: requestRole, isATeam: isATeam)
                
                requestList.append(requestModel)
                
                count += 1
                
                if count == maxCount {
                    onCompletion(.success(requestList))
                    return
                }
                
            }
        }
        
    }
    //accepts request from group side, returns true if request accepted and deleted
    //returns false if group does not accept request, due to them being fool, or due to sending user not existing or being in a different group
    private func getChatId(userId1: String, userId2: String) -> String {userId1 > userId2 ? userId1 + userId2 : userId2 + userId1}

    func acceptTeamRequest(deleteId:String,groupId:String,sendingID:String,onCompletion: @escaping(Result<Bool,DomainError>)->()){
        let groupRef = db.collection("group_v2")
       groupRef.document(groupId).getDocument { doc, error in
            guard let doc = doc, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            var alliances = doc.get("alliances") as! [String]
            
            if !alliances.contains(sendingID){
                alliances.append(sendingID)
            }
           groupRef.document(groupId).updateData(["alliances":alliances])
           groupRef.document(sendingID).getDocument { document, error in
               guard let document = document, error == nil else {
                   onCompletion(.failure(.downloadError))
                   return
               }
               var alliances = document.get("alliances") as! [String]
               
               if !alliances.contains(sendingID){
                   alliances.append(sendingID)
               }
              groupRef.document(sendingID).updateData(["alliances":alliances])
               
               
               self.db.collection("chats").document(self.getChatId(userId1: groupId, userId2: sendingID)).collection("messages")
               
               self.db.collection("requests_v1").document(deleteId).delete()
               onCompletion(.success(true))
           }
            
        }
    }
    func acceptJoinTeamRequest(request:RequestModel,onCompletion: @escaping(Result<Bool,DomainError>)->()){
        
        
        profileViewodel.fetchTeam(id: request.groupId) { result in
            switch result{
            case .success(let team):
                if team.teamMemberIDS.count == 6 {
                    onCompletion(.success(false))
                    return
                }
                self.profileViewodel.fetchMemberWithID(id:request.sendingRequestId) { result in
                    switch result{
                    case .success(let member):
                        if member.groupId != ""{
                            onCompletion(.success(false))
                            return
                        }
                        var teamMemberIDS = team.teamMemberIDS
                        var teamMemberRoles = team.teamMemberRoles
                        var teamMemberNames = team.teamMemberNames
                        
                        teamMemberIDS.append(request.sendingRequestId)
                        teamMemberNames.append(request.nameOfSender)
                        teamMemberRoles.append(request.sendRole)
                        
                        self.db.collection("group_v2").document(request.groupId).updateData([
                            "teamMemberIDS": teamMemberIDS,
                            
                            "teamMemberNames":teamMemberNames,
                            "teamMemberRoles" : teamMemberRoles
                        ])
                        self.db.collection("users_v2").document(request.sendingRequestId).updateData([
                            "groupId" : request.groupId
                        ])
                        self.db.collection("requests_v1").document(request.id).delete()
                        onCompletion(.success(true))
                        return
                        
                    case .failure(let error):
                        print("error fetching member accepting request \(error)")
                        onCompletion(.failure(.downloadError))
                        return
                    }
                }
               
                
            case .failure(let error):
                print("error accepting team request \(error)")
                onCompletion(.failure(.downloadError))
                return
            }
        }
    }
    func acceptRequest(request:RequestModel, onCompletion: @escaping(Result<Bool,DomainError>)->()){
        
        if request.isATeam {
            acceptTeamRequest(deleteId:request.id,groupId:request.groupId,sendingID: request.sendingRequestId, onCompletion: onCompletion)
        }else{
            acceptJoinTeamRequest(request:request, onCompletion: onCompletion)

        }
        
       
        
    }
    //updates the users in current group, then deletes request from cloud 
    func updateUsersGroup(sendId: String, groupId: String, onCompletion:@escaping(Result<Bool,DomainError>)->()){
        
        let userRef = db.collection("users_v2").document(sendId)
        
        userRef.getDocument { document , error in
            guard error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if let document = document, document.exists {
                userRef.updateData([
                    "groupId" : groupId
                ])
                
                self.cancelRequest(id: sendId) {
//                    let reqRef = self.db.collection("requests_v1").document(sendId)
//                    reqRef.updateData([
//                        "isFriends":true
//                    ])
                    onCompletion(.success(true))
                }
            }
            else{
                onCompletion(.success(false))
                return
            }
        }
        
    }
    
    //fetches single request sent by user waiting to enter team
    func fetchRequestForClient(onCompletion:@escaping (Result<RequestModel,DomainError>)->()){
        print("am i in here")
        
        if userId == nil {return}
        let requestRef = db.collection("requests_v1").document(userId!)
        
        requestRef.getDocument { document, error in
            if let document = document, document.exists{
                
                let requestSendingRequestId = document.get("sendingRequestId") as! String
                let requestNameOfSender = document.get("nameOfSender") as! String
                let requestGroupId = document.get("groupId") as! String
                let requestSendRole = document.get("sendRole") as! String
                
                let request : RequestModel = RequestModel(id: "", sendingRequestId: requestSendingRequestId, nameOfSender: requestNameOfSender, groupId: requestGroupId, sendRole: requestSendRole, isATeam: false)
                onCompletion(.success(request))
                return
            }
            else{
                onCompletion(.success(RequestModel(id: "", sendingRequestId: "", nameOfSender: "", groupId: "", sendRole: "", isATeam: false)))
                return
            }
        }
        
        

        
        
    }
    
    
    
}
