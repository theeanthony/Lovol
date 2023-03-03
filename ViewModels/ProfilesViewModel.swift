//
//  ProfilesViewModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/7/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import CoreData
import simd
import FirebaseStorage

class ProfilesViewModel: NSObject, ObservableObject{
    private let IMG_MAX_SIZE: Int64 = 10 * 1024 * 1024
    private let viewContext = PersistenceController.shared.container.viewContext
//    private let firestoreViewModel : FirestoreViewModel = FirestoreViewModfel()
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    private var userId: String? {
        Auth.auth().currentUser?.uid
        
        
    }
    
    private var fireUser : FirestoreUser2?

    private var updatedProfile : Bool = false

    private var groupId : String = ""

    private var teamName : String = ""
    
    
    func storeUserInLocal(fireUser : FirestoreUser2){
        
        if fireUser.groupId != nil{
            storeGroupId(id: fireUser.groupId!)
        }
        print("Storing user information in local \(fireUser.name)")
        self.fireUser = fireUser
        
    }
    func storeTeamName(teamName: String){
        self.teamName = teamName
    }
    func fetchUserFromLocal() -> FirestoreUser2 {
        if updatedProfile || fireUser == nil {
            fetchUserToUpdateLocal{
                print("updated in local")
                self.updatedProfile = false
            }
        }
        return fireUser!
    }

    
    func fetchUserId() -> String {
        return userId ?? "" 
    }
    func storeGroupId(id: String){
        
        if groupId != id {
            fetchUserToUpdateLocal {
                self.groupId = id
            }
        }
        else{
            groupId = id 
        }
  
    }
    func fetchGroupId() -> String {
        return groupId
    }
    
    func createCompleteGroup(name: String, bio:String, college: String, occupation:String, pictures: [UIImage], interests: [String], leftAnswers: [String], rightAnswers:[String], ownQuestions:[String],answers:[Int], entity:Int, interactionPreference: Int, longitude: Double, latitude: Double , city: String, distancePreference: Double, minYear: Int, maxYear: Int, onCompletion: @escaping(Result<Void,DomainError>)->()){
        
        print("STarting create group")
        print("name")
        let newGroupId = UUID().uuidString.substring(fromIndex: 26)
        print("GROUPID: \(newGroupId)")
    
        let userBirthday = fetchUserFromLocal().birthDate
        let firestoreGroup = FirestoreSquad(id: newGroupId, teamName: name, bio: bio, birthDate: userBirthday, usersInGroup: [userId!], liked: [], passed: [], groupInterests: interests, answers: answers, groupCollege: college, groupOccupation: occupation, formPreference: entity, interactionPreference: interactionPreference, maxDistancePreference: distancePreference, maxYearPreference: maxYear, minYearPreference: minYear, ownLeftAnswer: leftAnswers, ownRightAnswer: rightAnswers, ownQuestions: ownQuestions, isPartOfSwipe: false, points: 0, city: city, longitude: longitude, latitude: latitude)

                db.collection("group_v2").document(newGroupId).setData(firestoreGroup.dictionary)
                db.collection("group_v2").document(newGroupId).collection("messages")
            db.collection("group_v2").document(newGroupId).collection("group_events_v1")

                db.collection("users_v2").document(userId!).updateData([
                    "groupId" : newGroupId
                ])
        storeGroupId(id: newGroupId)
        storeTeamName(teamName: name)
        uploadGroupProfilePictures(groupId: newGroupId, pictures, onCompletion: onCompletion)
        let fireUser = FirestoreUser2(name: name, birthDate: userBirthday, bio: bio, gender: "", interests: interests, college: college, occupation: occupation, formPreference: entity, interactionPreference: interactionPreference, maxDistancePreference: distancePreference, maxYearPreference: maxYear, minYearPreference: minYear, pronouns: "", answersToGlobalQuestions: [], ownQuestions: ownQuestions, ownAnswers: answers, ownLeftAnswer: leftAnswers, ownRightAnswer: rightAnswers, longitude: longitude, latitude: latitude, liked: [], passed: [], groupId: newGroupId, isATeam: true, isDiscoverable: true, amountOfUsers: 1, swipeForTeam: false, city: city)
        db.collection("users_v2").document(newGroupId).setData(fireUser.dictionary)
        
    }
    //fetches single user, stores it in local cache
    func fetchUserToUpdateLocal(onCompletion:@escaping () -> ()){
        
        db.collection("users_v2").document(userId!).getDocument{document , error in
            guard error == nil else {
                onCompletion()
                return
            }
            if let document = document, document.exists {
                let decoder = JSONDecoder()
                var dict = document.data()
                for (key, value) in dict! {
                    if let value = value as? Date {
                        let formatter = DateFormatter()
                        dict?[key] = formatter.string(from:value)
                    }
                }
                let data = try? JSONSerialization.data(withJSONObject: dict!, options:[])
                do{
                    let fireUser = try decoder.decode(FirestoreUser2.self, from: data!)
                    if fireUser.groupId != ""{
                        self.storeGroupId(id: fireUser.groupId!)
                    }
                    else{
                        self.storeGroupId(id: "")
                    }
                    self.storeUserInLocal(fireUser: fireUser)
                    onCompletion()

                }
                catch{
                    print("ERROR PARSING USER")
                    print(error)
                    onCompletion()
                    }

            }
            
        }
        
    }
    func fetchUser(id:String, onCompletion:@escaping(Result<FirestoreUser2,DomainError>)->()){
        
        db.collection("users_v2").document(id).getDocument { document , error in
            guard error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if let document = document, document.exists {
                let decoder = JSONDecoder()
                var dict = document.data()
                for (key, value) in dict! {
                    if let value = value as? Date {
                        let formatter = DateFormatter()
                        dict?[key] = formatter.string(from:value)
                    }
                }
                let data = try? JSONSerialization.data(withJSONObject: dict!, options:[])
                do{
                    let fireUser = try decoder.decode(FirestoreUser2.self, from: data!)
                    onCompletion(.success(fireUser))
                }
                catch{
                    print("ERROR PARSING USER")
                    print(error)
                    onCompletion(.failure(.parsingError))
                    }

            }
            
        }
        
    }
    func fetchUserWO( onCompletion:@escaping(Result<FirestoreUser2,DomainError>)->()){
        
        if userId == nil {
            return 
        }
        
        db.collection("users_v2").document(userId!).getDocument { document , error in
            guard error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if let document = document, document.exists {
                let decoder = JSONDecoder()
                var dict = document.data()
                for (key, value) in dict! {
                    if let value = value as? Date {
                        let formatter = DateFormatter()
                        dict?[key] = formatter.string(from:value)
                    }
                }
                let data = try? JSONSerialization.data(withJSONObject: dict!, options:[])
                do{
                    let fireUser = try decoder.decode(FirestoreUser2.self, from: data!)
                    onCompletion(.success(fireUser))
                    return
                }
                catch{
                    print("ERROR PARSING USER")
                    print(error)
                    onCompletion(.failure(.parsingError))
                    return
                    }

            }
            
        }
        
    }
    func fetchGroup(id:String, onCompletion:@escaping(Result<FirestoreSquad,DomainError>)->()){
        
        
        db.collection("group_v1").document(id).getDocument { document , error in
            guard error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if let document = document, document.exists {
                let decoder = JSONDecoder()
                var dict = document.data()
                for (key, value) in dict! {
                    if let value = value as? Date {
                        let formatter = DateFormatter()
                        dict?[key] = formatter.string(from:value)
                    }
                }
                let data = try? JSONSerialization.data(withJSONObject: dict!, options:[])
                do{
                    let fireUser = try decoder.decode(FirestoreSquad.self, from: data!)
//                    self.storeTeamName(teamName: fireUser.teamName)
                    onCompletion(.success(fireUser))
                }
                catch{
                    print("ERROR PARSING USER")
                    print(error)
                    onCompletion(.failure(.parsingError))
                    }

            }
            
        }
        
    }
    
    func fetchMainPicture(profileId: String, onCompletion: @escaping(Result<UIImage, DomainError>)->()){
        print("fetching main pic")
        let picRef = storage.child("users_v2").child(profileId).child("profile_pic_0.jpg")
        picRef.getData(maxSize: self.IMG_MAX_SIZE) { data, error in
                if error != nil {
                    print("failure")
                    onCompletion(.failure(.downloadError))
                } else {
                    print("got the photo")
                    onCompletion(.success(UIImage(data: data!)!))
                }
        }
    }
    func fetchGroupMainPicture(profileId: String, onCompletion: @escaping(Result<UIImage, DomainError>)->()){
        let picRef = storage.child("group_v1").child(profileId).child("profile_pic_0.jpg")
        print("getting")
        picRef.getData(maxSize: self.IMG_MAX_SIZE) { data, error in
                if error != nil {
                    print("did not get thepi c")
                    onCompletion(.failure(.downloadError))
                } else {
                    print("got the pic")
                    onCompletion(.success(UIImage(data: data!)!))
                }
        }
    }
    
    func updateUserProfile(modified profileFields: [String: Any], onCompletion: @escaping (Result<Void,DomainError>) -> () ){
        let ref = db.collection("users_v2").document(userId!)
        ref.updateData(profileFields) { err in
            if err != nil {
                onCompletion(.failure(.uploadError))
            } else {
                
                print("Document successfully updated without photos")
                onCompletion(.success(()))
//                self.storeUserProfileInLocal(onCompletion: onCompletion)
            }
        }
    }
    func updateUserProfile(id: String, modified profileFields: [String: Any], onCompletion: @escaping (Result<Void,DomainError>) -> () ){
        let ref = db.collection("users_v2").document(id)
        ref.updateData(profileFields) { err in
            if err != nil {
                onCompletion(.failure(.uploadError))
            } else {
                
                print("Document successfully updated without photos")
                onCompletion(.success(()))
//                self.storeUserProfileInLocal(onCompletion: onCompletion)
            }
        }
    }
    func updateUserProfile(pictures: [UIImage], previousPicCount: Int, onCompletion: @escaping (Result<Void,DomainError>) -> () ){
        uploadProfilePictures( pictures, previousPicCount: previousPicCount, onCompletion: onCompletion)
    }

    func updateUserProfile( modified profileFields: [String: Any], pictures: [UIImage], previousPicCount: Int,  onCompletion: @escaping (Result<Void,DomainError>) -> () ){
        let ref = db.collection("users_v2").document(userId!)
        var otherTaskFinished = false
        ref.updateData(profileFields) { err in
            if err != nil {
                onCompletion(.failure(.uploadError))
            } else {
                print("Document successfully updated")
                if(otherTaskFinished){
//                    self.storeUserProfileInLocal(onCompletion: onCompletion)

                    onCompletion(.success(()))
                } else{
                    otherTaskFinished = true
                }
            }
        }

        uploadProfilePictures( pictures, previousPicCount: previousPicCount, onCompletion: {result in
            if(otherTaskFinished){
                onCompletion(result)
            } else {
                otherTaskFinished = true
            }
        })
    }
    private func uploadProfilePictures( _ pics: [UIImage], previousPicCount: Int = 0, onCompletion: @escaping (Result<Void,DomainError>) -> ()){
        let userRef = storage.child("users_v2").child(userId!)
        var localPictures: [LocalPicture] = []
        var count = 0

        if(previousPicCount > pics.count){
            for index in pics.count..<previousPicCount{
                let picRef = userRef.child("profile_pic_\(index).jpg")
                picRef.delete { error in
                    if error != nil {
                        onCompletion(.failure(.uploadError))
                    }
                }
            }
        }

        for (index, pic) in pics.enumerated(){
            let data = pic.jpegData(compressionQuality: 0.6)!
            let picRef = userRef.child("profile_pic_\(index).jpg")
            localPictures.append(LocalPicture())
            picRef.putData(data, metadata: nil) { (metadata, error) in
                guard let pictureMetadata = metadata else {
                    onCompletion(.failure(.downloadError))
                    return
                }
                localPictures[index].timestamp = pictureMetadata.timeCreated
                localPictures[index].data = data
                localPictures[index].position = Int16(index)

                count += 1

                if(count == pics.count){
                    let saveResult = self.saveLocalPictures(localPictures)
                    onCompletion(saveResult)
                }
            }
        }
    }
    func updateGroupProfile(groupId: String, modified profileFields: [String: Any], onCompletion: @escaping (Result<Void,DomainError>) -> () ){
        let ref = db.collection("group_v1").document(groupId)
        ref.updateData(profileFields) { err in
            if err != nil {
                onCompletion(.failure(.uploadError))
            } else {
                print("Group Document successfully updated")
                onCompletion(.success(()))
//                self.storeGroupProfileInLocal(onCompletion: onCompletion)
            }
        }
    }
    func updateGroupProfilePics(groupId: String, pictures: [UIImage], previousPicCount: Int, onCompletion: @escaping (Result<Void,DomainError>) -> () ){
        uploadGroupProfilePictures(groupId: groupId, pictures, previousPicCount: previousPicCount, onCompletion: onCompletion)
    }




    func updateGroupProfile(groupId:String, modified profileFields: [String: Any], pictures: [UIImage], previousPicCount: Int,  onCompletion: @escaping (Result<Void,DomainError>) -> () ){
        let ref = db.collection("group_v2").document(groupId)
        var otherTaskFinished = false
        ref.updateData(profileFields) { err in
            if err != nil {
                onCompletion(.failure(.uploadError))
            } else {
                print("Document successfully updated")
                if(otherTaskFinished){
                    onCompletion(.success(()))
                } else{
                    otherTaskFinished = true
                }
            }
        }

        uploadGroupProfilePictures(groupId:groupId, pictures, previousPicCount: previousPicCount, onCompletion: {result in
            if(otherTaskFinished){
                onCompletion(result)
            } else {
                otherTaskFinished = true
            }
        })
    }
    private func uploadGroupProfilePictures(groupId: String, _ pics: [UIImage], previousPicCount: Int = 0, onCompletion: @escaping (Result<Void,DomainError>) -> ()){
        let userRef = storage.child("group_v1").child(groupId)
        var localPictures: [LocalGroupPicture] = []
        var count = 0

        if(previousPicCount > pics.count){
            for index in pics.count..<previousPicCount{
                let picRef = userRef.child("profile_pic_\(index).jpg")
                picRef.delete { error in
                    if error != nil {
                        onCompletion(.failure(.uploadError))
                    }
                }
            }
        }
        print("pics count \(pics.count)")
        for (index, pic) in pics.enumerated(){
            let data = pic.jpegData(compressionQuality: 0.6)!
            let picRef = userRef.child("profile_pic_\(index).jpg")
            localPictures.append(LocalGroupPicture())
            picRef.putData(data, metadata: nil) { (metadata, error) in
                guard let pictureMetadata = metadata else {
                    onCompletion(.failure(.downloadError))
                    return
                }
                localPictures[index].timestamp = pictureMetadata.timeCreated
                localPictures[index].data = data
                localPictures[index].position = Int16(index)

                count += 1

                if(count == pics.count){
                    let saveResult = self.saveLocalGroupPictures(localPictures)
                    onCompletion(saveResult)
                }
            }
        }
    }
    private func saveLocalPictures(_ localPictures: [LocalPicture]) -> Result<Void,DomainError>{
        let deleteResult = deleteAllLocalPictures()
        switch deleteResult{
        case .failure(_):
            return deleteResult
        case .success(_):
            for picture in localPictures {
                let newProfilePic = ProfilePicture(context: viewContext)
                newProfilePic.timestamp = picture.timestamp
                newProfilePic.picture = picture.data
                newProfilePic.position = picture.position
            }

            do {
                try viewContext.save()
                return .success(())
            } catch {
                return .failure(.localSavingError)
            }
        }
    }
    private func saveLocalGroupPictures(_ localPictures: [LocalGroupPicture]) -> Result<Void,DomainError>{
        let deleteResult = deleteAllLocalGroupPictures()
        switch deleteResult{
        case .failure(_):
            return deleteResult
        case .success(_):
            for picture in localPictures {
                let newProfilePic = ProfilePicture(context: viewContext)
                newProfilePic.timestamp = picture.timestamp
                newProfilePic.picture = picture.data
                newProfilePic.position = picture.position
            }

            do {
                try viewContext.save()
                return .success(())
            } catch {
                return .failure(.localSavingError)
            }
        }
    }
    private func deleteAllLocalPictures() ->Result<Void, DomainError>{
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ProfilePicture.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        let batchDeleteFetchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteFetchRequest.resultType = .resultTypeObjectIDs
        do {
            let batchDelete = try viewContext.execute(batchDeleteFetchRequest)
                as? NSBatchDeleteResult

            guard let deleteResult = batchDelete?.result
                as? [NSManagedObjectID]
            else { return .failure(.localSavingError)}

            let deletedObjects: [AnyHashable: Any] = [
                NSDeletedObjectsKey: deleteResult
            ]

            // Merge the delete changes into the managed
            // object context
            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: deletedObjects,
                into: [viewContext]
            )
            return .success(())
        } catch {
            return .failure(.localSavingError)
        }
    }
    private func deleteAllLocalGroupPictures() ->Result<Void, DomainError>{
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = ProfilePicture.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        let batchDeleteFetchRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteFetchRequest.resultType = .resultTypeObjectIDs
        do {
            let batchDelete = try viewContext.execute(batchDeleteFetchRequest)
                as? NSBatchDeleteResult

            guard let deleteResult = batchDelete?.result
                as? [NSManagedObjectID]
            else { return .failure(.localSavingError)}

            let deletedObjects: [AnyHashable: Any] = [
                NSDeletedObjectsKey: deleteResult
            ]

            // Merge the delete changes into the managed
            // object context
            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: deletedObjects,
                into: [viewContext]
            )
            return .success(())
        } catch {
            return .failure(.localSavingError)
        }
    }
    func updateConversion( groupId: String, onCompletion: @escaping(Result<Void,DomainError>)->()){

        fetchGroup(id: groupId) { groupResult in

            switch (groupResult){
            case .success(let group):


                let firestoreUser = FirestoreUser2(name: group.teamName, birthDate: group.birthDate, bio: group.bio, gender: "", interests: group.groupInterests, college: group.groupCollege, occupation: group.groupOccupation, formPreference: group.formPreference, interactionPreference: group.interactionPreference, maxDistancePreference: group.maxDistancePreference, maxYearPreference: group.maxYearPreference, minYearPreference: group.minYearPreference, pronouns: "", answersToGlobalQuestions: group.answers, ownQuestions: group.ownQuestions, ownAnswers: group.answers, ownLeftAnswer: group.ownLeftAnswer, ownRightAnswer: group.ownRightAnswer, liked: group.liked, passed: group.passed, groupId: group.id.substring(fromIndex: 26), isATeam: true, isDiscoverable: group.isPartOfSwipe, amountOfUsers: group.usersInGroup.count, swipeForTeam: false, city: group.city)

                self.db.collection("users_v2").document(groupId).updateData(firestoreUser.dictionary)



            case .failure(let error):
                print("ERROR UPDATING CONVERSION: \(error)")
                onCompletion(.failure(.downloadError))

            }


        }

    }
    func fetchGroupConvo(id: String,subPic:UIImage, onCompletion: @escaping (Result<ChatModel, DomainError>)->()){
        
        
//        self.fetchGroupMainPicture(profileId: id, onCompletion: {pictureResult in
//            switch pictureResult{
//            case .success(let picture):
                self.db.collection("group_v2").document(id).getDocument { doc, error in
                    guard let doc = doc , error == nil else {
                        onCompletion(.failure(.downloadError))
                        return
                    }
                    self.db.collection("group_v2").document(id).collection("messages").order(by: "timestamp", descending: false).getDocuments { document, error in
                        
                        let groupName = doc.get("teamName") as! String
                        if let document = document, document.isEmpty {
                            let groupMatch = ChatModel(id: id, groupId: id, name: groupName, picture: subPic, lastMessage: nil)
                                onCompletion(.success(groupMatch))
                            return
                            
                        }
                        else{
                            let lastMessageIndex = document!.count - 1
                            let lastDocument = document?.documents[lastMessageIndex]
                            let lastMessage = lastDocument!.get("message") as! String
                            let groupMatch = ChatModel(id: id, groupId: id, name: groupName, picture:subPic, lastMessage: lastMessage)
                                onCompletion(.success(groupMatch))
                            return
                        }
                    }
                }

  
//            case .failure(let error):
//                onCompletion(.failure(error))
//                return
//            }
//        })
//
        
    }
    private func getChatId(userId1: String, userId2: String) -> String {userId1 > userId2 ? userId1 + userId2 : userId2 + userId1}

    func fetchAllianceConvos(groupId:String, ids: [String], subPic:UIImage,onCompletion: @escaping (Result<[ChatModel], DomainError>)->()){
        
        
        var count = 0
        var maxCount = ids.count
        
        if maxCount == 0 {
            onCompletion(.success([]))
            return
        }
        
        var chatModels : [ChatModel] = []
        
        for id in ids{
//            self.fetchGroupMainPicture(profileId: id, onCompletion: {pictureResult in
//                switch pictureResult{
//                case .success(let picture):
                    self.db.collection("chats").document(self.getChatId(userId1: groupId, userId2: id)).collection("messages").order(by: "timestamp", descending: false).getDocuments { query, error in
                        guard let doc = query , error == nil else {
//                            onCompletion(.failure(.downloadError))
//                            return
                            count += 1
                            return
                        }
                        self.db.collection("group_v2").document(id).getDocument { document, error in
                            guard let document = document, error == nil else {
                                onCompletion(.failure(.downloadError))
                                count += 1
                                return
                            }
                            let teamName = document.get("teamName") as! String
                            if  doc.isEmpty {
                                let groupMatch = ChatModel(id: id, groupId: id, name: teamName, picture: subPic, lastMessage: nil)
                                
                                chatModels.append(groupMatch)
                                count += 1
                                
                                if count == maxCount {
                                    onCompletion(.success(chatModels))
                                    return

                                }
                                
                            }
                            else{
                                let lastMessageIndex = doc.count - 1
                                let lastDocument = doc.documents[lastMessageIndex]
                                let lastMessage = lastDocument.get("message") as! String
                                let groupMatch = ChatModel(id: id, groupId: id, name: teamName, picture: subPic, lastMessage: lastMessage)
                                print("Last message \(lastMessage)")
                                chatModels.append(groupMatch)
                                count += 1
                                
                                if count == maxCount {
                                    onCompletion(.success(chatModels))
                                    return

                                }
                            }
                            
                        }

                    }

//
//                case .failure(let error):
//                    onCompletion(.failure(error))
//                    return
//                }
//            })
        }

        
        
    }
    
    func fetchOwnGroupConvo(id: String, onCompletion: @escaping (Result<MatchModel, DomainError>)->()){
        
        
        self.fetchGroupMainPicture(profileId: self.groupId, onCompletion: {pictureResult in
            switch pictureResult{
            case .success(let picture):
                self.db.collection("group_v2").document(id).getDocument { doc, error in
                    guard let doc = doc , error == nil else {
                        onCompletion(.failure(.downloadError))
                        return
                    }
                    self.db.collection("group_v2").document(id).collection("messages").getDocuments { document, error in
                        
                        let groupName = doc.get("teamName") as! String
                        if let document = document, document.isEmpty {
                            let groupMatch = MatchModel(id: id, userId: id, name: groupName, birthDate: Date(), picture: picture, lastMessage: nil, isGroup: true)
                                onCompletion(.success(groupMatch))
                            return
                            
                        }
                        else{
                            let lastMessageIndex = document!.count - 1
                            let lastDocument = document?.documents[lastMessageIndex]
                            let lastMessage = lastDocument!.get("message") as! String
                           let groupMatch = MatchModel(id: id, userId: id, name: groupName, birthDate: Date(), picture: picture, lastMessage: lastMessage, isGroup: true)
                                onCompletion(.success(groupMatch))
                            return
                        }
                    }
                }

  
            case .failure(let error):
                onCompletion(.failure(error))
                return
            }
        })
        
        
    }
    func checkGroupSize(id:String, onCompletion:@escaping(Result<Int,DomainError>)->()){
        
        let groupRef = db.collection("group_v2").document(id)
        
        groupRef.getDocument { document, error in
            guard let document = document, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            let teamMembers = document.get("teamMemberIDS") as! [String]
            
            onCompletion(.success(teamMembers.count))
            return
            
        }
        
    }
    func leaveGroup(onCompletion: @escaping (Result<Void,DomainError>)->()){

        if userId == nil {
            onCompletion(.failure(.downloadError))
            return
        }

        let docRef = db.collection("users_v2").document(userId!)

        docRef.updateData([
            "groupId" : ""
        ])

        fetchUserToUpdateLocal {
            onCompletion(.success(()))
        }
        
    }

    func leaveGroupArray(groupId: String, onCompletion: @escaping (Result<Void,DomainError>)->()){

        let groupRef = db.collection("group_v2").document(groupId)
        groupRef.getDocument {(doc, error) in

        if let document = doc, document.exists {
            let decoder = JSONDecoder()
            var dict = document.data()
            for (key, value) in dict! {
             //We need to check if the value is a Date (timestamp) and parse it as a string, since you cant serialize a Date. This might be true for other types you have serverside.
             if let value = value as? Date {
               let formatter = DateFormatter()
                 dict?[key] = formatter.string(from: value)
                }
              }
            let data = try? JSONSerialization.data(withJSONObject: dict!, options:[])

            do{
                let fireGroup = try decoder.decode(FirestoreSquad.self, from: data!)
                print("in group do")
                var groupArray = fireGroup.usersInGroup
                let removeId = self.userId

                groupArray.removeAll {$0 == removeId}
                groupRef.updateData([
                    "usersInGroup" : groupArray
                ])
                if groupArray.count == 0 {
                    groupRef.delete()
//                    self.db.collection("users_v2").document(groupId).delete()
                    self.db.collection("users_v2").document(groupId).updateData(["isDiscoverable" : false])

                    
                }
                self.storeGroupId(id: "")

                self.leaveGroup(onCompletion: onCompletion)
                return

            }
            catch{
                onCompletion(.failure(.uploadError))
                print(error)
                return
                }

            }
            else{
                print("no fetching group profile error")
                onCompletion(.failure(.downloadError))
                return
            }
        }
    }
    
    func searchTeam(id: String, onCompletion: @escaping (Result<SearchModel,DomainError>)->()){
        db.collection("group_v2").document(id).getDocument { document , error in
            guard error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if let document = document, document.exists {
                print("document exists")
                let decoder = JSONDecoder()
                var dict = document.data()
                for (key, value) in dict! {
                    if let value = value as? Date {
                        let formatter = DateFormatter()
                        dict?[key] = formatter.string(from:value)
                    }
                }
                let data = try? JSONSerialization.data(withJSONObject: dict!, options:[])
                do{
                    let fireUser = try decoder.decode(SearchModel.self, from: data!)
//                    self.storeTeamName(teamName: fireUser.teamName)
                    onCompletion(.success(fireUser))
                    return
                }
                catch{
                    print("ERROR PARSING USER")
                    print(error)
                    onCompletion(.failure(.parsingError))
                    }

            }else{
                print("document does not exist")
                onCompletion(.success(SearchModel()))
                return
            }
            
        }
    }
    func createTeam(info: TeamModel, name: String, role:String, teamPic: UIImage, id:String,onCompletion: @escaping (Result<Void,DomainError>)->()){
        
//        let randomID : String = UUID().uuidString.substring(fromIndex: 26)
        let randomID = id 
        let firebaseTeam : FirebaseTeam = FirebaseTeam(id: randomID, teamName: info.teamName, teamDescription: info.teamDescription, teamRule: info.teamRule, teamPoints: 0, teamMemberNames: [name], teamMemberRoles: [role], teamMemberIDS: [userId!] ,suggestedEvents: [], chosenEvent: "", requests: [],achievements: [], alliances: [], exists: true, setTimeForChosenEvent: "", teamLovols: 0, lifeTimeLovols: 0, city: "", long : 0, lat: 0, timeCreated: "", locationSet: false, address: "", lifetimeLovolBits: 0, totalEventsCompleted: 0,multiplier:0,resurrection:0,isMember: false)
        
        var set : [String : Any] = firebaseTeam.dictionary
        set["timeCreated"] = FieldValue.serverTimestamp()
        set["setTimeForChosenEvent"] = FieldValue.serverTimestamp()
 
            
   
        db.collection("group_v2").document(randomID).setData(set)
        
        db.collection("users_v2").document(userId!).updateData([
            "groupId" : randomID,
            "groupName" : info.teamName
        ])
        
        uploadGroupProfilePictures(groupId: randomID, [teamPic], onCompletion: onCompletion)
         
        
    }
    func createUser(name: String, role: String, pic : UIImage , age: Bool, onCompletion: @escaping (Result<Void,DomainError>)->()){
        
        let fireMember : FireMember = FireMember(id: userId!, name: name, role: role, groupId: "", groupName: "", over21: age)
        db.collection("users_v2").document(userId!).setData(fireMember.dictionary)
        
            uploadProfilePictures([pic], onCompletion: onCompletion)
    }
    func fetchMember (onCompletion:@escaping(Result<FireMember,DomainError>)->()){
        
        print("in fetch member")
        if userId == nil {
            
            print("user id is nil")
            return
        }
        
        db.collection("users_v2").document(userId!).getDocument { document , error in
            guard error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if let document = document, document.exists {
                print("fetch member doocument exists ")
                let decoder = JSONDecoder()
                var dict = document.data()
                for (key, value) in dict! {
                    if let value = value as? Date {
                        let formatter = DateFormatter()
                        dict?[key] = formatter.string(from:value)
                    }
                }
                let data = try? JSONSerialization.data(withJSONObject: dict!, options:[])
                do{
                    let fireUser = try decoder.decode(FireMember.self, from: data!)
                    print("user \(fireUser)")
                    onCompletion(.success(fireUser))
                    return
                }
                catch{
                    print("ERROR PARSING USER")
                    print(error)
                    onCompletion(.failure(.parsingError))
                    return
                    }

            }else{
                print("document misssing??? ")
            }
            
        }
        
    }
    func fetchMemberWithID (id:String,onCompletion:@escaping(Result<FireMember,DomainError>)->()){
        
        print("in fetch member")
        if userId == nil {
            
            print("user id is nil")
            return
        }
        
        db.collection("users_v2").document(id).getDocument { document , error in
            guard error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if let document = document, document.exists {
                print("fetch member doocument exists ")
                let decoder = JSONDecoder()
                var dict = document.data()
                for (key, value) in dict! {
                    if let value = value as? Date {
                        let formatter = DateFormatter()
                        dict?[key] = formatter.string(from:value)
                    }
                }
                let data = try? JSONSerialization.data(withJSONObject: dict!, options:[])
                do{
                    let fireUser = try decoder.decode(FireMember.self, from: data!)
                    print("user \(fireUser)")
                    onCompletion(.success(fireUser))
                    return
                }
                catch{
                    print("ERROR PARSING USER")
                    print(error)
                    onCompletion(.failure(.parsingError))
                    return
                    }

            }else{
                print("document misssing??? ")
            }
            
        }
        
    }
    func fetchTeamMembers(groupId: String,onCompletion:@escaping(Result<MemberModel,DomainError>)->()){
    }
    func fetchTeam(id:String, onCompletion:@escaping(Result<FirebaseTeam,DomainError>)->()){
        db.collection("group_v2").document(id).getDocument { document , error in
            guard error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if let document = document, document.exists {
                let decoder = JSONDecoder()
                var dict = document.data()
                for (key, value) in dict! {

                 if let value = value as? Timestamp {
                     let formatter = DateFormatter()
                     formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                     let newValue = value.dateValue()
                     dict?[key] = formatter.string(from: newValue)
                    }
                  }
                let data = try? JSONSerialization.data(withJSONObject: dict!, options:[])
                do{
                    let fireUser = try decoder.decode(FirebaseTeam.self, from: data!)
//                    self.storeTeamName(teamName: fireUser.teamName)
                    print("fire user \(fireUser.setTimeForChosenEvent)")
                    onCompletion(.success(fireUser))
                }
                catch{
                    print("ERROR PARSING USER")
                    print(error)
                    onCompletion(.failure(.parsingError))
                    }
            }
        }
        
    }
    func fetchMainPictureV1(members: [MemberModel], onCompletion: @escaping(Result<[MemberModel], DomainError>)->()){
        
        var count = 0
        let maxCount = members.count
        var newMembers : [MemberModel] = []
        
     
        print("in member model")
        for member in members {
            let picRef = storage.child("users_v2").child(member.id).child("profile_pic_0.jpg")
            picRef.getData(maxSize: self.IMG_MAX_SIZE) { data, error in
                    if error != nil {
                        let newMember : MemberModel = MemberModel(id: member.id, name: member.name, role: member.role, pic: UIImage(named:"elon_musk")!)
                        count += 1
                        newMembers.append(newMember)
                        if count == maxCount {
                            onCompletion(.success(newMembers))
                            return
                        }
//                        return
//                        onCompletion(.failure(.downloadError))
                    } else {
                        print("added")
                        let newMember : MemberModel = MemberModel(id: member.id, name: member.name, role: member.role, pic: UIImage(data: data!)!)
                        count += 1

                        newMembers.append(newMember)
                        if count == maxCount {
                            onCompletion(.success(newMembers))
                            return
                        }
//                        return
                    }
                
            }
      

        }
    }
    func fetchRequestsWithPictures(requests: [RequestModelPicture], onCompletion: @escaping(Result< [RequestModelPicture], DomainError>)->()){
        
        var count = 0
        let maxCount = requests.count
        var newMembers : [RequestModelPicture] = []
        
        for request in requests {
            var pictureStorage : String = ""
            if request.request.isATeam {
                pictureStorage = "group_v1"
            }else{
                pictureStorage = "users_v2"

            }
            print("picture stoarge \(pictureStorage)")
            let picRef = storage.child(pictureStorage).child(request.request.sendingRequestId).child("profile_pic_0.jpg")
            picRef.getData(maxSize: self.IMG_MAX_SIZE) { data, error in
                    if error != nil {
                        let newMember : RequestModelPicture = RequestModelPicture(request:request.request, pic: UIImage(named:"elon_musk")!)
                        count += 1
                        newMembers.append(newMember)
                        if count == maxCount {
                            onCompletion(.success(newMembers))
                            return
                        }
                    } else {
                        
                        let newMember : RequestModelPicture = RequestModelPicture(request:request.request, pic: UIImage(data: data!)!)
                        count += 1

                        newMembers.append(newMember)
                        if count == maxCount {
                            onCompletion(.success(newMembers))
                            return
                        }
//                        return
                    }
                
            }
      

        }
    }
    func fetchAllianceTeamPics(groupIDS : [String], onCompletion:@escaping(Result<[AllianceModel],DomainError>)->()){
        let groupRef = db.collection("group_v2")
        var allianceModel : [AllianceModel] = []
        if groupIDS.isEmpty {
            onCompletion(.success([]))
            return
        }
        var count = 0
        let maxCount = groupIDS.count
        for id in groupIDS {
            groupRef.document(id).getDocument { groupDocument, error in
                guard let groupDocument = groupDocument , error == nil else {
                    onCompletion(.failure(.downloadError))
                    return
                }
                let groupId = groupDocument.get("id") as! String

                let teamName = groupDocument.get("teamName") as! String
                let teamDescription = groupDocument.get("teamDescription") as! String
                let teamMemberIDS = groupDocument.get("teamMemberIDS") as! [String]
                let teamMemberNames = groupDocument.get("teamMemberNames") as! [String]

                let teamMemberRoles = groupDocument.get("teamMemberRoles") as! [String]
                var memberModels : [MemberModel] = []

                for index in teamMemberIDS.indices {
                    let memberModel : MemberModel = MemberModel(id: teamMemberIDS[index], name: teamMemberNames[index], role: teamMemberRoles[index], pic: UIImage())
                    memberModels.append(memberModel)
                }
                self.fetchGroupMainPicture(profileId: id) { result in
                    switch result {
                    case .success(let teamPic):
                        let alliance : AllianceModel = AllianceModel(groupId: groupId, teamName: teamName, teamDescription: teamDescription, memberModel: memberModels, teamPic: teamPic)
                        allianceModel.append(alliance)
                        
                        count += 1
                        
                        if count == maxCount {
                            onCompletion(.success(allianceModel))
                            return
                        }
                    case .failure(let error):
                        print("error fetching team pic \(error)")
                        let alliance : AllianceModel = AllianceModel(groupId: groupId, teamName: teamName, teamDescription: teamDescription, memberModel: memberModels, teamPic: UIImage(named: "elon_musk")!)
                        allianceModel.append(alliance)
                        
                        count += 1
                        
                        if count == maxCount {
                            onCompletion(.success(allianceModel))
                            return
                        }
                    }
                }

                

                
            }
        }
//        return
        
        
    }
    func sendAllianceRequest(id:String, sendingTeam : FirebaseTeam, onCompletion:@escaping (Result<Bool,DomainError>)->()){
        
        
        db.collection("requests_v1").whereField("groupId", isEqualTo: id).getDocuments { query, error in
            guard let documents = query, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if documents.documents.count > 0 {
                onCompletion(.success(true))
                return
            }
            else{
                let randomId = UUID().uuidString
                
                
                let requestRef = self.db.collection("requests_v1").document(randomId)
                
                requestRef.setData([
                
                    "groupId" : id,
                    
                    "isATeam" : true,
                    "isFriends" : false,
                    "nameOfSender" : sendingTeam.teamName,
                    "sendRole" : "Team",
                    
                    "sendingRequestId": sendingTeam.id
                    
                
                ])
                onCompletion(.success(false))
                return
            }
        }
        
    }
    func searchAllianceWithoutPictures(ids : [String] , onCompletion: @escaping(Result<[AllianceModel], DomainError>)->()){
        let groupRef = db.collection("group_v2")
        
        var count = 0
        let maxCount = ids.count
        var allAlliances : [AllianceModel] = []
        
        for id in ids {
            groupRef.document(id).getDocument { groupDocument, error in
                guard let groupDocument = groupDocument , error == nil else {
                    onCompletion(.failure(.downloadError))
                    return
                }
                    let groupId = groupDocument.get("id") as! String
                    
                    let teamName = groupDocument.get("teamName") as! String
                
                    let teamDescription = groupDocument.get("teamDescription") as! String
                    let teamMemberIDS = groupDocument.get("teamMemberIDS") as! [String]
                    let teamMemberNames = groupDocument.get("teamMemberNames") as! [String]
//
                    let teamMemberRoles = groupDocument.get("teamMemberRoles") as! [String]
                    var memberModels : [MemberModel] = []
                for index in teamMemberIDS.indices {
                    let memberModel : MemberModel = MemberModel(id: teamMemberIDS[index], name: teamMemberNames[index], role: teamMemberRoles[index], pic: UIImage())
                    memberModels.append(memberModel)
                }
                let alliance : AllianceModel = AllianceModel(groupId: groupId, teamName: teamName, teamDescription: teamDescription, memberModel: memberModels, teamPic: UIImage())
                allAlliances.append(alliance)
                count += 1
                if count == maxCount {
                    onCompletion(.success(allAlliances))
                    return
                }

                }
        }

    
    }
    func searchAlliance(id : String , onCompletion: @escaping(Result<AllianceModel, DomainError>)->()){
        let groupRef = db.collection("group_v2")
            groupRef.document(id).getDocument { groupDocument, error in
//                guard let groupDocument = groupDocument , error == nil else {
//                    onCompletion(.failure(.downloadError))
//                    return
//                }
                if let groupDocument = groupDocument, groupDocument.exists {
                    let groupId = groupDocument.get("id") as! String

                    let teamName = groupDocument.get("teamName") as! String
                    let teamDescription = groupDocument.get("teamDescription") as! String
                    let teamMemberIDS = groupDocument.get("teamMemberIDS") as! [String]
                    let teamMemberNames = groupDocument.get("teamMemberNames") as! [String]

                    let teamMemberRoles = groupDocument.get("teamMemberRoles") as! [String]
                    var memberModels : [MemberModel] = []

                    for index in teamMemberIDS.indices {
                        let memberModel : MemberModel = MemberModel(id: teamMemberIDS[index], name: teamMemberNames[index], role: teamMemberRoles[index], pic: UIImage())
                        memberModels.append(memberModel)
                    }
                    self.fetchMainPictureV1(members: memberModels) { result in
                        switch result{
                        case .success(let members):
                            self.fetchGroupMainPicture(profileId: id) { result in
                                switch result{
                                case .success(let teamPic):
                                    let alliance : AllianceModel = AllianceModel(groupId: groupId, teamName: teamName, teamDescription: teamDescription, memberModel: members, teamPic: teamPic)
                                    print("success receiving team pic ")
                                    onCompletion(.success(alliance))
                                    return
                                    
                                case .failure(let error):
                                    print("could not fetch team pic \(error)")
                                    let alliance : AllianceModel = AllianceModel(groupId: groupId,teamName: teamName, teamDescription: teamDescription, memberModel: members, teamPic: UIImage(named:"elon_musk")!)
                                    onCompletion(.success(alliance))
                                    return
                                    
                                }
                            }
                     
                            
                        case .failure(let error):
                            print("error fetching this alliance \(error)")
                            return
                        }
                    }
                }else{
                    onCompletion(.failure(.downloadError))
                    return
                }
                
               
                

                
            }
    
    }
    
    func fetchAlliances(groupIDS : [String] , onCompletion: @escaping(Result<[AllianceModel], DomainError>)->()){
        let groupRef = db.collection("group_v2")
        var allianceModel : [AllianceModel] = []
        var count = 0
        var maxCount = groupIDS.count
        for id in groupIDS {
            groupRef.document(id).getDocument { groupDocument, error in
                guard let groupDocument = groupDocument , error == nil else {
                    onCompletion(.failure(.downloadError))
                    return
                }
                let groupId = groupDocument.get("id") as! String

                let teamName = groupDocument.get("teamName") as! String
                print("TEam name \(teamName)")
                let teamDescription = groupDocument.get("teamDescription") as! String
                let teamMemberIDS = groupDocument.get("teamMemberIDS") as! [String]
                let teamMemberNames = groupDocument.get("teamMemberNames") as! [String]

                let teamMemberRoles = groupDocument.get("teamMemberRoles") as! [String]
                var memberModels : [MemberModel] = []

                for index in teamMemberIDS.indices {
                    let memberModel : MemberModel = MemberModel(id: teamMemberIDS[index], name: teamMemberNames[index], role: teamMemberRoles[index], pic: UIImage())
                    memberModels.append(memberModel)
                }
                self.fetchMainPictureV1(members: memberModels) { result in
                    switch result{
                    case .success(let members):
                        self.fetchGroupMainPicture(profileId: id) { result in
                            switch result{
                            case .success(let teamPic):
                                let alliance : AllianceModel = AllianceModel(groupId: groupId, teamName: teamName, teamDescription: teamDescription, memberModel: members, teamPic: teamPic)
                                allianceModel.append(alliance)
                                count += 1
                                if count == maxCount {
                                    onCompletion(.success(allianceModel))
                                    return
                                }
                          
                                
                            case .failure(let error):
                                print("could not fetch team pic \(error)")
                                let alliance : AllianceModel = AllianceModel(groupId: groupId,teamName: teamName, teamDescription: teamDescription, memberModel: members, teamPic: UIImage(named:"elon_musk")!)
                                allianceModel.append(alliance)
                                count += 1

                                if count == maxCount {
                                    onCompletion(.success(allianceModel))
                                    return
                                }
                            }
                        }
                 
                        
                    case .failure(let error):
                        print("error fetching this alliance \(error)")
                        return
                    }
                }
                

                
            }
        }
  
    }
    
   func fetchLatestEventInfo(groupId:String, onCompletion: @escaping(Result<[String],DomainError>)->()){
       let eventRef = db.collection("group_v2").document(groupId).collection("group_events_v1").order(by: "timestamp", descending: true).limit(to: 1)
       
       eventRef.getDocuments { query, error in
           guard let documents = query, error == nil else {
               onCompletion(.failure(.downloadError))
               return
           }
           if documents.documents.isEmpty {
               onCompletion(.success([]))
               return
           }
           
           let document = documents.documents[0]
           
           let eventName = document.get("eventName") as! String
           let eventURL = document.get("photoURL") as! [String]
           
           onCompletion(.success([eventName,"eventURL"]))
           return
       }
    }
    func fetchLeaders(onCompletion:@escaping(Result<[LeaderBoardModel],DomainError>)->()){
        
        let leadersRef = db.collection("group_v2").order(by:"teamPoints", descending: true).limit(to: 3)
        
//        let groupRef = db.collection("group_v2").order(by:"teamPoints", descending: false)
        var count = 0
        let maxCount = 3
        var leaders : [LeaderBoardModel] = []
        
        leadersRef.getDocuments { query, error in
            guard let documents = query, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            
            for document in documents.documents {
                
                let teamName = document.get("teamName") as! String
                let teamPoints = document.get("teamPoints") as! Int
                let groupId = document.get("id") as! String
                
                self.fetchGroupMainPicture(profileId: groupId) { result in
                    switch result {
                    case .success(let pic):
                        let leader : LeaderBoardModel = LeaderBoardModel(teamName: teamName, teamPoints: teamPoints, teamPic: pic)
                        leaders.append(leader)
                        
                        count += 1
                        if count == maxCount {
                            onCompletion(.success(leaders))
                            return
                        }
                    case .failure(let error):
                        print("error fetching team pic for leaders \(error)")
                        let leader : LeaderBoardModel = LeaderBoardModel(teamName: teamName, teamPoints: teamPoints, teamPic: UIImage(named:"elon_musk")!)
                        leaders.append(leader)
                        
                        count += 1
                        if count == maxCount {
                            onCompletion(.success(leaders))
                            return
                        }
                    }
                }
                
            }
            
        }

        
        
    }
    func fetchLeaderBoard(groupId:String, onCompletion:@escaping (Result<[BoardModel],DomainError>)->()){
        
        
        let leadersRef = db.collection("group_v2").order(by:"teamPoints", descending: true)
        
//        let groupRef = db.collection("group_v2").order(by:"teamPoints", descending: false)
        var count = 0
        var leaders : [BoardModel] = []
        
        leadersRef.getDocuments { query, error in
            guard let documents = query, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            
            if documents.documents.count < 5 {
                
                for document in documents.documents {
                    
                    let teamName = document.get("teamName") as! String
                    let teamPoints = document.get("teamPoints") as! Int
                    let teamRank = count + 1
                    
                    let boardModel : BoardModel = BoardModel(teamName: teamName, teamPoints: teamPoints, ranking: teamRank, id: document.documentID)
                    leaders.append(boardModel)
                    
                    count += 1
                    
                    if count == documents.documents.count {
                        onCompletion(.success(leaders))
                        return
                    }
                    
                }
            }else{
                
                for document in documents.documents {
                    
                    
                    
                    if document.documentID == groupId {
                        
                        var index = count
                        
                        print("Index \(index)")
                        
                        let teamName = document.get("teamName") as! String
                        let teamPoints = document.get("teamPoints") as! Int
                        let teamRank = index + 1
                        
                        let boardModel : BoardModel = BoardModel(teamName: teamName, teamPoints: teamPoints, ranking: teamRank, id: document.documentID)
                        leaders.append(boardModel)
                        
                        var fourLeft : Int = 4
                        var startingLeftIndex : Int = index - 1
                        var startingRightIndex : Int = index + 1

                        while fourLeft != 0 {
                            if startingLeftIndex >= 0 {
                                let documentLeft = documents.documents[startingLeftIndex]
                                let teamName = documentLeft.get("teamName") as! String
                                let teamPoints = documentLeft.get("teamPoints") as! Int
                                let teamLeftRank = index + 1
                                
                                let boardModel : BoardModel = BoardModel(teamName: teamName, teamPoints: teamPoints, ranking: startingLeftIndex + 1 , id: documentLeft.documentID)
                                leaders.append(boardModel)
                                fourLeft -= 1
                                startingLeftIndex -= 1

                            }
                            if startingRightIndex < documents.documents.count {
                                let documentRight = documents.documents[startingRightIndex]
                                let teamName = documentRight.get("teamName") as! String
                                let teamPoints = documentRight.get("teamPoints") as! Int
                                let teamRightRank = index + 1
                                
                                let boardModel : BoardModel = BoardModel(teamName: teamName, teamPoints: teamPoints, ranking: startingRightIndex + 1, id: documentRight.documentID)
                                leaders.append(boardModel)

                                fourLeft -= 1
                                startingRightIndex += 1

                            }
                        }
                        onCompletion(.success(leaders))
                        return
                        
                        
                        
                        
                    }
                    count += 1
                    
                }
            }
        }
        
    }
    func fetchTeamWithoutID(onCompletion:@escaping(Result<FirebaseTeam,DomainError>)->()){
        
        if userId == nil {
            return
        }
        db.collection("users_v2").document(userId!).getDocument { doc, error in
            guard error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if let document = doc, document.exists {
                
                let id = document.get("groupId") as! String
                if id == ""{
                    onCompletion(.failure(.parsingError))
                    return
                }
                self.fetchTeam(id: id, onCompletion: onCompletion)
                
                
            }
            else{
                onCompletion(.failure(.downloadError))
                return
            }

            
        }
        
        
    }
    
    func saveAddress(address:String, long:Double,lat:Double,city:String, onCompletion:@escaping(Result<Bool,DomainError>)->()){
        
        fetchMember { result in
            switch result{
            case .success(let member):
                
                if member.groupId == "" {
                    onCompletion(.success(false))
                    return
                }
                self.db.collection("group_v2").document(member.groupId).updateData([
                
                    "long" :long ,
                    "lat" : lat,
                    "city" : city ,
                    "address": address,
                    "locationSet" : true
                    
                ])
                onCompletion(.success(true))
                return 
            case .failure(let error):
                print("error retrieving member for saving address \(error)")
                onCompletion(.failure(.downloadError))
                return
            }
        }
        
    }
    
    func fetchOtherTeamProfile(groupId:String,onCompletion:@escaping(Result<AllianceModel,DomainError>)->()){
        
    }
    func sendGroupMessage(groupId: String, message: String, isOwn:Bool){
        
        if isOwn{
            sendGroup(groupId:groupId,message:message)
        }else{
            sendAllianceMessage(groupId:groupId,message:message)
        }


    }
    func sendAllianceMessage(groupId:String,message:String){
        fetchMember { result in
            switch result {
            case .success(let user):

                self.db.collection("chats").document(self.getChatId(userId1: groupId, userId2: user.groupId)).collection("messages")
                    .addDocument(data:
                                    ["message" : message,
                                     "senderId" : self.userId!,
                                     "timestamp" : FieldValue.serverTimestamp(),
                                     "senderName" : user.name,
                                     "senderGroupId" : user.groupId,
                                     "recipientId" : groupId

                                    ])
            case .failure(let error):
                print("Error sending message \(error)")
            }
        }
    }
    func sendGroup(groupId:String,message:String){
        fetchMember { result in
            switch result {
            case .success(let user):
                
                
//                var dateTime = Date().shortDateTime
                self.db.collection("group_v2").document(groupId).collection("messages")
                    .addDocument(data:
                                    ["message" : message,
                                     "senderId" : self.userId!,
                                     "timestamp" :  FieldValue.serverTimestamp(),
                                     "senderName" : user.name,
                                     "recipientId" : groupId

                                    ])
            case .failure(let error):
                print("Error sending message \(error)")
            }
        }
    }
//    func whoToListenTo(match:ChatModel,groupId:String,own:Bool, onUpdate: @escaping (Result<[MessageModel], DomainError>) -> ()){
//        
//        if own {
//            listenToGroupMessages(groupId: groupId, onUpdate: onUpdate)
//        }else{
//            listenToAllianceMessages(chatId: match.groupId, groupId:groupId,onUpdate:onUpdate)
//        }
//        
//    }
    func listenToAllianceMessages(chatId:String,groupId: String, onUpdate: @escaping (Result<[MessageModel], DomainError>) -> ()) -> ListenerRegistration{
        
        
        let listener = db.collection("chats").document(self.getChatId(userId1: groupId, userId2: chatId)).collection("messages").order(by: "timestamp", descending: false).addSnapshotListener({ querySnapshot, error in
            guard let documents = querySnapshot?.documents, error == nil else {
                onUpdate(.failure(.downloadError))
                return
            }



            let messages: [MessageModel] = documents.compactMap{ document in
//
                let decoder = JSONDecoder()
                var dict = document.data()
//
                for (key, value) in dict {

                if let value = value as? Timestamp {
                    let formatter = DateFormatter()
                    let newValue = value.dateValue()
                    formatter.dateStyle = .short
                    formatter.timeStyle = .none
                    dict[key] = formatter.string(from: newValue)
                   }
                 }
//
                let data = try? JSONSerialization.data(withJSONObject: dict, options:[])

                do {
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "mm/dd/yy"
//                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
//                    print("date formatter \(decoder.dataDecodingStrategy)")
//                    print("Doing")
                    let firestoreMessage = try decoder.decode(FirestoreMessage.self, from: data!)
                    return MessageModel.from(id: document.documentID, firestoreMessage, currentUserId: self.userId!, name: firestoreMessage.senderName)
                    
                }
                catch{
                    print("Error listenign tomeessag \(error)")
                    return nil
                }

            }
            onUpdate(.success(messages))

            })


        return listener
    }
    func listenToGroupMessages(groupId: String, onUpdate: @escaping (Result<[MessageModel], DomainError>) -> ()) -> ListenerRegistration{
        
        print("inside listen to group messages \(groupId)")
        
        let listener = db.collection("group_v2").document(groupId).collection("messages").order(by: "timestamp", descending: false).addSnapshotListener({ querySnapshot, error in
            guard let documents = querySnapshot?.documents, error == nil else {
                onUpdate(.failure(.downloadError))
                return
            }



            let messages: [MessageModel] = documents.compactMap{ document in
//
                let decoder = JSONDecoder()
                var dict = document.data()
//
                for (key, value) in dict {

                if let value = value as? Timestamp {

                    let formatter = DateFormatter()
                    let newValue = value.dateValue()
                    formatter.dateStyle = .short
                    formatter.timeStyle = .none
                    dict[key] = formatter.string(from: newValue)
                    print("new date \(String(describing: dict[key]))")
                   }
                 }
//
                let data = try? JSONSerialization.data(withJSONObject: dict, options:[])

                do {
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateFormat = "mm/dd/yy"
//                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    let firestoreMessage = try decoder.decode(FirestoreMessage.self, from: data!)
                    return MessageModel.from(id: document.documentID, firestoreMessage, currentUserId: self.userId!, name: firestoreMessage.senderName)
                    
                }
                catch{
                    print(error)
                    return nil
                }

            }
            onUpdate(.success(messages))

            })


        return listener
    }
 
    
    
}
