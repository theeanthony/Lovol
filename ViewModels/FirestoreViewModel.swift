//
//  FirestoreViewModel.swift
//  Lovol (iOS)
//
//  Created by Anthony Contreras on 10/18/22.
//


import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import CoreData
import simd
import FirebaseStorage
import AVKit
import UserNotifications
import FirebaseDynamicLinks
import UIKit

enum DomainError: Error{
    case uploadError, downloadError, parsingError, localSavingError, localfetchingError
}


class FirestoreViewModel: NSObject, ObservableObject{
    private let IMG_MAX_SIZE: Int64 = 10 * 1024 * 1024
    private let viewContext = PersistenceController.shared.container.viewContext
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    private var lastDocQuery: DocumentSnapshot!
    @Published var isFetchingMoreDocs: Bool = false
    private var completedFetches : [NewUserProfile] = []

//    private let profileViewModel : ProfilesViewModel = ProfilesViewModel()
    private var userId: String? {
        Auth.auth().currentUser?.uid

    }
    
    private var serverPublicInfo : FirebaseServer?
    

        //reporting user
    func reportUser(id: String, reportSheet: ReportModel){
        
        
        print("id \(id)")
        db.collection("reported_users").document(id).getDocument { document, error in
            if let document = document, document.exists {
                print("document report exist")

                var existingReports : [String] = document.get("report") as! [String]
                existingReports.append(contentsOf: reportSheet.reason)
                let existingCount = document.get("timesReported") as! Int
                self.db.collection("reported_users").document(id).updateData([
                    
                    "report" : existingReports,
                    "timesReported" : existingCount + 1

                ])
            }else{
                print("document doesxnt exist")
        //        report.reports.append(reportSheet)
                self.db.collection("reported_users").document(id).setData([
                    "id" : id,
                    "report" : reportSheet.reason,
                    "timesReported" : 1
                ])
            }
        }

    }
//videos
    func fileOutput(groupId: String, _ output: AVCaptureFileOutput,
                       didFinishRecordingTo outputFileURL: URL,
                       from connections: [AVCaptureConnection],
                       error: Error?) {
           guard let data = try? Data(contentsOf: outputFileURL) else {
               return
           }

           print("File size before compression: \(Double(data.count / 1048576)) mb")

           let compressedURL = NSURL.fileURL(withPath: NSTemporaryDirectory() + UUID().uuidString + ".mp4")
           compressVideo(inputURL: outputFileURL as URL,
                         outputURL: compressedURL) { exportSession in
               guard let session = exportSession else {
                   return
               }

               switch session.status {
               case .unknown:
                   break
               case .waiting:
                   break
               case .exporting:
                   break
               case .completed:
                   guard let compressedData = try? Data(contentsOf: compressedURL) else {
                       return
                   }
                   let metadata = StorageMetadata()
                   metadata.contentType = "video/mp4"
                   
                   print("File size after compression: \(Double(compressedData.count / 1048576)) mb")
                   let ref = self.storage.child("group_v2").child(groupId).child("events_v1").child("videos/bonusEvent.mp4")
                   ref.putData(compressedData, metadata: metadata)
                   let uploadTask = ref.putFile(from: compressedURL, metadata: metadata) { metadata, error in
                     guard let metadata = metadata else {
                         print("Error uploading video \(String(describing: error))")
                       return
                     }
                       
                       return
                     // Metadata contains file metadata such as size, content-type.
           //          let size = metadata.size
           //          // You can also access to download URL after upload.
           //          videoRef.downloadURL { (url, error) in
           //            guard let downloadURL = url else {
           //              // Uh-oh, an error occurred!
           //              return
           //            }
           //          }
                   }
                  
               case .failed:
                   break
               case .cancelled:
                   break
               @unknown default:
                   break
               }
           }
       }
    
    func uploadVideo(groupId: String, onCompletion:@escaping(Result<Void,DomainError>)->()){
        //make sure to change reference for groups so that whenever they cash their points in, a new reference is made for the images and videos uploaded when getting new sets of points
        let ref = storage.child("group_v2").child(groupId).child("events_v1")
        let videoRef = storage.child("videos/bonusEvent.mp4")
        let metadata = StorageMetadata()
        metadata.contentType = "video/mp4"
        videoRef.putData(Data(), metadata: metadata)
        
        let filename = UUID().uuidString
        let localFile = URL(string: "\(filename)")!
        let uploadTask = videoRef.putFile(from: localFile, metadata: metadata) { metadata, error in
          guard let metadata = metadata else {
              print("Error uploading video \(String(describing: error))")
              onCompletion(.failure(.uploadError))
            return
          }
            onCompletion(.success(()))
            return
          // Metadata contains file metadata such as size, content-type.
//          let size = metadata.size
//          // You can also access to download URL after upload.
//          videoRef.downloadURL { (url, error) in
//            guard let downloadURL = url else {
//              // Uh-oh, an error occurred!
//              return
//            }
//          }
        }

    }
    func compressVideo(inputURL: URL,
                           outputURL: URL,
                           handler:@escaping (_ exportSession: AVAssetExportSession?) -> Void) {
            let urlAsset = AVURLAsset(url: inputURL, options: nil)
            guard let exportSession = AVAssetExportSession(asset: urlAsset,
                                                           presetName: AVAssetExportPresetMediumQuality) else {
                handler(nil)

                return
            }

            exportSession.outputURL = outputURL
            exportSession.outputFileType = .mp4
            exportSession.exportAsynchronously {
                handler(exportSession)
            }
        }



    //CREATING USER PROFILE
    func createUserProfile(name: String, bio: String, birthDate: Date, college: String, occupation: String, gender : String ,pictures: [UIImage], interests: [String], currentValues: [Int], leftAnswers: [String], rightAnswers: [String], ownQuestions: [String], answers: [Int], typeOfEntity: Int, interactionPreference: Int, longitude: Double, latitude: Double, city: String, distance: Double, minAge: Int, maxAge: Int, pronouns: String, onCompletion: @escaping (Result<Void,DomainError>)->()){
        let profilesViewModel = ProfilesViewModel()
        let fireUser = FirestoreUser2(name: name, birthDate: birthDate, bio: bio, gender: gender, interests: interests, college: college, occupation: occupation, formPreference: typeOfEntity, interactionPreference: interactionPreference, maxDistancePreference: distance, maxYearPreference: maxAge , minYearPreference: minAge, pronouns: pronouns, answersToGlobalQuestions:currentValues, ownQuestions: ownQuestions, ownAnswers: answers, ownLeftAnswer: leftAnswers, ownRightAnswer: rightAnswers, liked: [], passed: [], groupId: "", isATeam: false, isDiscoverable: true, amountOfUsers: 1, swipeForTeam: false, city: city)
        
        db.collection("users_v2").document(userId!).setData(fireUser.dictionary)
        

        profilesViewModel.storeUserInLocal(fireUser: fireUser)
        uploadProfilePictures(pictures, onCompletion: onCompletion)
    }

    






    //UPDATING IMAGES AND PROFILES

    private func performImageUpdate(_ updatedPictures: [LocalPicture], _ onUpdate: @escaping (Result<[UIImage], DomainError>)->()){
        let fetchRequest = ProfilePicture.fetchRequest()
        if let localPictures = try? viewContext.fetch(fetchRequest){
            for updatedPicture in updatedPictures {
                if let localPicture = localPictures.first(where: { $0.position == updatedPicture.position}){
                    localPicture.picture = updatedPicture.data
                    localPicture.timestamp = updatedPicture.timestamp
                } else {
                    let newProfilePic = ProfilePicture(context: viewContext)
                    newProfilePic.timestamp = updatedPicture.timestamp
                    newProfilePic.picture = updatedPicture.data
                    newProfilePic.position = updatedPicture.position
                }
            }

            do {
                try viewContext.save()

                let returnedImages: [UIImage] = updatedPictures.sorted(by: { $0.position < $1.position }).compactMap{ UIImage(data: $0.data!) }

                onUpdate(.success(returnedImages))
            } catch {
                onUpdate(.failure(.localSavingError))
            }
        } else{
            onUpdate(.failure(.localfetchingError))
            return
        }


    }




    //UPLOADING PROFILE PICUTES

    private func uploadGroupProfilePictures(groupId: String, _ pics: [UIImage], previousPicCount: Int = 0, onCompletion: @escaping (Result<Void,DomainError>) -> ()){
        let userRef = storage.child("group_v2").child(groupId)
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
    private func uploadProfilePictures(_ pics: [UIImage], previousPicCount: Int = 0, onCompletion: @escaping (Result<Void,DomainError>) -> ()){
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

    //SAVING AND DELETING LOCAL PICTURES
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

    //SENDING MESSAGES
    func sendMessage(matchId: String, message: String){
        
        fetchUserProfile { result in
            switch result {
            case .success(let user):
                self.db.collection("matches").document(matchId).collection("messages")
                    .addDocument(data:
                                    ["message" : message,
                                     "senderId" : self.userId!,
                                     "timestamp" : FieldValue.serverTimestamp(),
                                     "senderName" : user.name,
                                     "recipientId" : matchId
                                    ])
            case .failure(let error):
                print("Error sending message \(error)")
            }
        }

    }
    func sendGroupMessage(groupId: String, message: String){
        
        fetchUserProfile { result in
            switch result {
            case .success(let user):
                self.db.collection("group_v2").document(groupId).collection("messages")
                    .addDocument(data:
                                    ["message" : message,
                                     "senderId" : self.userId!,
                                     "timestamp" : FieldValue.serverTimestamp(),
                                     "senderName" : user.name,
                                     "recipientId" : groupId

                                    ])
            case .failure(let error):
                print("Error sending message \(error)")
            }
        }

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
                   }
                 }
//
                let data = try? JSONSerialization.data(withJSONObject: dict, options:[])

                do {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "mm/dd/yy"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
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
    func listenToMessages(matchId: String, onUpdate: @escaping (Result<[MessageModel], DomainError>) -> ()) -> ListenerRegistration{
        let listener = db.collection("matches").document(matchId).collection("messages").order(by: "timestamp", descending: false).addSnapshotListener({ querySnapshot, error in
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
                    formatter.dateFormat = "mm/dd/yy"

                    let newValue = value.dateValue()
                    formatter.dateStyle = .short
                    formatter.timeStyle = .none
                    dict[key] = formatter.string(from: newValue)
                    print("Time stamp of messages \(newValue)")
                   }
                 }
//
                let data = try? JSONSerialization.data(withJSONObject: dict, options:[])

                do {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "mm/dd/yy"
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)
                    let firestoreMessage = try decoder.decode(FirestoreMessage.self, from: data!)
                    return MessageModel.from(id: document.documentID, firestoreMessage, currentUserId: self.userId!, name: firestoreMessage.senderName)
                    
                }
                catch{
                    print(error)
                    return nil
                }

            }
            let content = UNMutableNotificationContent()
            content.title = "New Message"
            content.subtitle = "It looks hungry"
            content.sound = UNNotificationSound.default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

            // choose a random identifier
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

            // add our notification request
            UNUserNotificationCenter.current().add(request)
            onUpdate(.success(messages))

            })


        return listener
    }


//

//
//    if let data = try? JSONSerialization.data(withJSONObject: dict, options:[]){
 
    //FETCHING MATCHES AND PICTURES AND SWIPING VIEWS
    func fetchUserProfile(fetchedUserId: String? = nil ,onCompletion: @escaping (Result<FirestoreUser2, DomainError>) ->()){
        var usedId: String = fetchedUserId ?? ""
        if usedId == "" {
            if userId == nil{
                print("USER ID IS NIL")
                onCompletion(.failure(.downloadError))
                return
            }
            else{
                usedId = userId!
            }
        }
        db.collection("users_v2").document(usedId).getDocument { document, error in
            guard let document = document, error == nil else{
                print("ERROR FETCHING DOCUMENT IN FETCH USER")
                print(error as Any)
                onCompletion(.failure(.downloadError))
                return
            }
            let decoder = JSONDecoder()
            var dict = document.data()
            for (key, value) in dict! {


             if let value = value as? Date {
               let formatter = DateFormatter()
                 dict?[key] = formatter.string(from: value)
                }
              }

            let data = try? JSONSerialization.data(withJSONObject: dict!, options:[])
            do{
                let fireUser = try decoder.decode(FirestoreUser2.self, from: data!)
                onCompletion(.success(fireUser))
            }
            catch{
                print("ERROR PARSING USER 2")
                print(error)
                onCompletion(.failure(.parsingError))
                }


        }
    }
    func fetchOtherUserProfile(fetchedUserId: String ,onCompletion: @escaping (Result<FirestoreUser2, DomainError>) ->()){

        db.collection("users_v2").document(fetchedUserId).getDocument { document, error in
            guard let document = document, error == nil else{
                print("ERROR FETCHING DOCUMENT IN FETCH USER")
                print(error as Any)
                onCompletion(.failure(.downloadError))
                return
            }
            let decoder = JSONDecoder()
            var dict = document.data()
            for (key, value) in dict! {


             if let value = value as? Date {
               let formatter = DateFormatter()
                 dict?[key] = formatter.string(from: value)
                }
              }

            let data = try? JSONSerialization.data(withJSONObject: dict!, options:[])
            do{
                let fireUser = try decoder.decode(FirestoreUser2.self, from: data!)
                onCompletion(.success(fireUser))
            }
            catch{
                print("ERROR PARSING USER 1 ")
                print(error)
                onCompletion(.failure(.parsingError))
                }


        }
    }
    func fetchGroupAndUserMatches(groupId:String, onCompletion:@escaping (Result<[MatchModel],DomainError>)->()){
        
        
        if groupId != "" {
            fetchMatchesForGroupAndUsers(groupId: groupId, onCompletion: onCompletion)
            return
        }
        else{
            fetchMatches(onCompletion: onCompletion)
            return
        }
        
    }
    func fetchMatchesForGroupAndUsers(groupId:String, onCompletion:@escaping (Result<[MatchModel], DomainError>)->()){
        
        fetchMatches { result in
            switch result {
            case .success(let matches):
                var newMatches = matches
                self.fetchMatches(groupId: groupId) { result in
                    switch result {
                    case .success(let groupMatches):
                        newMatches.append(contentsOf: groupMatches)
                        onCompletion(.success(newMatches))
                        return
                    case .failure(let error):
                        onCompletion(.failure(error))
                        return
                    }
                }
            case  .failure(let error):
                onCompletion(.failure(error))
                return
            }
        }
        
    }
    

    func fetchMatches(groupId: String, onCompletion: @escaping (Result<[MatchModel], DomainError>) -> ()){

      
        db.collection("matches").whereField("usersMatched", arrayContains: groupId).order(by:"timestamp", descending: true).getDocuments(completion: {doc, err in
            guard let documentSnapshot = doc, err == nil else{
                onCompletion(.failure(.downloadError))
                return
            }
            var matchList: [MatchModel] = []
            var count = 0
            let maxCount = documentSnapshot.documents.count
            var hasFailed = false
            if maxCount == 0 {
                onCompletion(.success([]))
            }
            for document in documentSnapshot.documents{
                if hasFailed{ break }

                let decoder = JSONDecoder()
                var dict = document.data()

                for (key, value) in dict {

                if let value = value as? Timestamp {

                    let formatter = DateFormatter()
                    let newValue = value.dateValue()
                    formatter.dateStyle = .short
                    formatter.timeStyle = .none
                    dict[key] = formatter.string(from: newValue)
                   }
                 }

                if let data = try? JSONSerialization.data(withJSONObject: dict, options:[]){

                    do {

                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "mm/dd/yy"
                        decoder.dateDecodingStrategy = .formatted(dateFormatter)


                        let match = try decoder.decode(FirestoreMatch.self, from: data)
                        let matchId : String = match.usersMatched.filter{$0 != groupId}.first!

                        self.fetchUserProfile(fetchedUserId: matchId, onCompletion: { result in
                            switch result{
                            case .success(let user):
                                if user.isATeam {
                                    let teamId = user.groupId
                                    self.fetchMainGroupPicture(profileId: teamId!, onCompletion: {pictureResult in
                                        if hasFailed {return}
                                        switch pictureResult{
                                        case .success(let picture):
                                            self.db.collection("matches").document(self.getMatchId(userId1: groupId, userId2: matchId)).collection("messages").getDocuments { documentMessage, error in
                                                if let documentMessage = documentMessage, documentMessage.isEmpty {
                                                    matchList.append(MatchModel(id: document.documentID, userId: matchId, name: user.name, birthDate: user.birthDate, picture: picture, lastMessage: nil, isGroup: user.isATeam))
                                                    print("there is no message")
                                                    count += 1

                                                    if (count == maxCount){
                                                        print("completed \(matchList)")
                                                        onCompletion(.success(matchList))
                                                    }
                                                }
                                                else{
                                                    let lastMessageIndex = documentMessage!.count - 1
                                                    let lastDocument = documentMessage?.documents[lastMessageIndex]
                                                    let lastMessage = lastDocument!.get("message") as! String
                                                    print("there is message \(lastMessage)")
                                                    matchList.append(MatchModel(id: document.documentID, userId: matchId, name: user.name, birthDate: user.birthDate, picture: picture, lastMessage: lastMessage, isGroup: user.isATeam))
                                                    count += 1

                                                    if (count == maxCount){
                                                        print("completed \(matchList)")
                                                        onCompletion(.success(matchList))
                                                        return
                                                    }
                                                }
                                            }
                                        case .failure(let error):
                                            onCompletion(.failure(error))
                                            hasFailed = true
                                            return
                                        }
                                    })
                                }
                                else{
                                    
                                    self.fetchMainPicture(profileId: matchId, onCompletion: {pictureResult in
                                        if hasFailed {
                                            print("Has failed fetching mainpictures")
                                            return
                                        }
                                        print("has not failed")
                                        switch pictureResult{
                                        case .success(let picture):
                                            self.db.collection("matches").document(self.getMatchId(userId1: groupId, userId2: matchId)).collection("messages").getDocuments { documentMessage, error in
                                                if let documentMessage = documentMessage, documentMessage.isEmpty {
                                                    matchList.append(MatchModel(id: document.documentID, userId: matchId, name: user.name, birthDate: user.birthDate, picture: picture, lastMessage: nil, isGroup: user.isATeam))
                                                    print("there is no message")
                                                    count += 1

                                                    if (count == maxCount){
                                                        print("completed \(matchList)")
                                                        onCompletion(.success(matchList))
                                                    }
                                                }
                                                else{
                                                    let lastMessageIndex = documentMessage!.count - 1
                                                    let lastDocument = documentMessage?.documents[lastMessageIndex]
                                                    let lastMessage = lastDocument!.get("message") as! String
                                                    print("there is message \(lastMessage)")
                                                    matchList.append(MatchModel(id: document.documentID, userId: matchId, name: user.name, birthDate: user.birthDate, picture: picture, lastMessage: lastMessage, isGroup: user.isATeam))
                                                    count += 1

                                                    if (count == maxCount){
                                                        print("completed \(matchList)")
                                                        onCompletion(.success(matchList))
                                                        return
                                                    }
                                                }
                                            }
                                        case .failure(let error):
                                            print("has failed")
                                            print(error)
                                            onCompletion(.failure(error))
                                            hasFailed = true
                                            return
                                        }
                                    })
                                    return

                                    
                                }
                            case .failure(let error):
                                print("failure fetching user")
                                onCompletion(.failure(error))
                                return
                            }
                        })
                    }
                    catch{
                        print("Caught error")
                        print(error)
                    }

                }

            }
        })
    }
    func fetchMatches(onCompletion: @escaping (Result<[MatchModel], DomainError>) -> ()){

        guard let userId = userId else {
            print("UserID not found in fetch matches")
            return
        }
        let matchRef =  db.collection("matches").whereField("usersMatched", arrayContains: userId)
       matchRef.getDocuments(completion: {doc, err in
            guard let documentSnapshot = doc, err == nil else{
                onCompletion(.failure(.downloadError))
                return
            }
            var matchList: [MatchModel] = []
            var count = 0
            let maxCount = documentSnapshot.documents.count
            if maxCount == 0 {
                onCompletion(.success([]))
                return
            }
            var hasFailed = false
            for document in documentSnapshot.documents{
                if hasFailed{ break }
                let decoder = JSONDecoder()
                var dict = document.data()
                for (key, value) in dict {

                if let value = value as? Timestamp {

                    let formatter = DateFormatter()
                    let newValue = value.dateValue()
                    formatter.dateStyle = .short
                    formatter.timeStyle = .none
                    dict[key] = formatter.string(from: newValue)
                   }
                 }

                if let data = try? JSONSerialization.data(withJSONObject: dict, options:[]){

                    do {

                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "mm/dd/yy"
                        decoder.dateDecodingStrategy = .formatted(dateFormatter)


                        let match = try decoder.decode(FirestoreMatch.self, from: data)
                        let matchId : String = match.usersMatched.filter{$0 != self.userId!}.first!

                        self.fetchUserProfile(fetchedUserId: matchId, onCompletion: { result in
                            switch result{
                            case .success(let user):
                                
                                
                                if user.isATeam {
                                    let teamId = user.groupId
                                    self.fetchMainGroupPicture(profileId: teamId!, onCompletion: {pictureResult in
                                        if hasFailed {return}
                                        switch pictureResult{
                                        case .success(let picture):
                                            self.db.collection("matches").document(self.getMatchId(userId1: userId, userId2: matchId)).collection("messages").getDocuments { documentMessage, error in
                                                if let documentMessage = documentMessage, documentMessage.isEmpty {
                                                    matchList.append(MatchModel(id: document.documentID, userId: matchId, name: user.name, birthDate: user.birthDate, picture: picture, lastMessage: nil, isGroup: user.isATeam))
                                                    print("there is no message")
                                                    count += 1

                                                    if (count == maxCount){
                                                        print("completed \(matchList)")
                                                        onCompletion(.success(matchList))
                                                    }
                                                }
                                                else{
                                                    let lastMessageIndex = documentMessage!.count - 1
                                                    let lastDocument = documentMessage?.documents[lastMessageIndex]
                                                    let lastMessage = lastDocument!.get("message") as! String
                                                    print("there is message \(lastMessage)")
                                                    matchList.append(MatchModel(id: document.documentID, userId: matchId, name: user.name, birthDate: user.birthDate, picture: picture, lastMessage: lastMessage, isGroup: user.isATeam))
                                                    count += 1

                                                    if (count == maxCount){
                                                        print("completed \(matchList)")
                                                        onCompletion(.success(matchList))
                                                        return
                                                    }
                                                }
                                            }
                                        case .failure(let error):
                                            onCompletion(.failure(error))
                                            hasFailed = true
                                            return
                                        }
                                    })
                                }
                                
                                
                                
                                else{
                                    self.fetchMainPicture(profileId: matchId, onCompletion: {pictureResult in
                                        if hasFailed {return}
                                        switch pictureResult{
                                        case .success(let picture):
                                            self.db.collection("matches").document(self.getMatchId(userId1: userId, userId2: matchId)).collection("messages").getDocuments { documentMessage, error in
                                                if let documentMessage = documentMessage, documentMessage.isEmpty {
                                                    matchList.append(MatchModel(id: document.documentID, userId: matchId, name: user.name, birthDate: user.birthDate, picture: picture, lastMessage: nil, isGroup: user.isATeam))
                                                    print("there is no message")
                                                    count += 1
                                                    
                                                    if (count == maxCount){
                                                        print("completed \(matchList)")
                                                        onCompletion(.success(matchList))
                                                        return
                                                    }
                                                }
                                                else{
                                                    let lastMessageIndex = documentMessage!.count - 1
                                                    let lastDocument = documentMessage?.documents[lastMessageIndex]
                                                    let lastMessage = lastDocument!.get("message") as! String
                                                    print("there is message \(lastMessage)")
                                                    matchList.append(MatchModel(id: document.documentID, userId: matchId, name: user.name, birthDate: user.birthDate, picture: picture, lastMessage: lastMessage, isGroup: user.isATeam))
                                                    count += 1
                                                    
                                                    if (count == maxCount){
                                                        print("completed \(matchList)")
                                                        onCompletion(.success(matchList))
                                                        return
                                                    }
                                                }
                                            }
                                            
                                            return
                                        case .failure(let error):
                                            onCompletion(.failure(error))
                                            hasFailed = true
                                            return
                                        }
                                    })
                                    
                                }
                                
                                return
                            case .failure(let error):
                                onCompletion(.failure(error))
                                return
                            }
                        })
                    }
                    catch{
                        print(error)
                    }

                }

            }
        })
    }

    private func getMatchId(userId1: String, userId2: String) -> String {userId1 > userId2 ? userId1 + userId2 : userId2 + userId1}
    
    func fetchMatchesQuestions(matchId: String, userId: String,onCompletion:@escaping (Result<BothMatchQuestionsModel,DomainError>)->()){
        
        db.collection("matches").document(getMatchId(userId1: matchId, userId2: userId)).getDocument(completion: { document, error in
            
                
            guard let document = document , error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
                print(matchId)
            print(userId)
                let swipeAnswers = document.get("swipeAnswers") as! [Int]
                let swipeQuestions = document.get("swipeQuestions") as! [String]
                let swipeLeftExamples = document.get("swipeLeftExamples") as! [String]
                let swipeRightExamples = document.get("swipeRightExamples") as! [String]
                let swipeName = document.get("swipeName") as! String
            let swipeOwnAnswers = document.get("swipeAnswersToOwnQuestions") as! [Int]
            let userOwnAnswers = document.get("userSwipingOnOwnAnswers") as! [Int]
                let usersName = document.get("usersName") as! String
                let userAnswers = document.get("userAnswers") as! [Int]
                let userQuestions = document.get("userQuestions") as! [String]
                let userLeftExamples = document.get("userLeftExamples") as! [String]
                let userRightExamples = document.get("userRightExamples") as! [String]
            let model : BothMatchQuestionsModel = BothMatchQuestionsModel(swipeAnswers: swipeAnswers, swipeQuestions: swipeQuestions, swipeLeftExamples: swipeLeftExamples, swipeRightExamples: swipeRightExamples, swipeName: swipeName, swipeOwnAnswers: swipeOwnAnswers,  usersName: usersName, userAnswers: userAnswers, userQuestions: userQuestions, userLeftExamples: userLeftExamples, userRightExamples: userRightExamples, userOwnAnswers: userOwnAnswers)
                onCompletion(.success(model))

        })
        
    }
    
    func swipeUser(teamSwipe: Bool, groupId: String, name: String, swipedUserId: String, hasLiked: Bool, chosenAnswers: [Int], chosenQuestions:[String], leftQuestions:[String], rightQuestions: [String],onMatch: @escaping () -> ()){
        guard let userId = userId else {
            print("Could not retrieve userId")
            return
        }
        var usedId : String = ""
        if teamSwipe == true {
            print("team swipe")
            usedId = groupId
        }
        else{
            print("no team swipe")
            usedId = userId
        }
        print("USED ID \(usedId)")
            db.collection("users_v2").document(usedId).updateData([
                (hasLiked ? FirestoreUser2.CodingKeys.liked.rawValue : FirestoreUser2.CodingKeys.passed.rawValue) : FieldValue.arrayUnion([swipedUserId])
            ])
        if !hasLiked{return}
        db.collection("users_v2").document(usedId).getDocument { document, error in
            guard let document = document, error == nil else {
                return
            }
            let answersToMyOwnQuestions = document.get("ownAnswers") as! [Int]
            self.db.collection("users_v2").document(usedId).collection(FirestoreUser2.CodingKeys.liked.rawValue).document(swipedUserId).setData(
                ["exists" : true,
                 "leftAnswers" : chosenAnswers,
                 "leftQuestions" : chosenQuestions,
                 "leftleftExamples" : leftQuestions,
                 "leftRightExamples" : rightQuestions,
                "leftName" : name,
                 "leftAnswersToMyOwn" : answersToMyOwnQuestions
                ]
            
            )
        }

        
            db.collection("users_v2").document(swipedUserId).collection("liked").document(usedId).getDocument(completion: { doc, err in
           if let document = doc, document.exists {
               self.db.collection("users_v2").document(swipedUserId).collection("liked").document(usedId).getDocument { docs, error in
                   guard let documentSnapshot = docs, err == nil else {
                       return
                   }
                   let swipeQuestions = documentSnapshot.get("leftQuestions") as! [String]
                   let swipeLeftExamples = documentSnapshot.get("leftleftExamples") as! [String]
                   let swipeRightExamples = documentSnapshot.get("leftRightExamples") as! [String]
                   let swipeAnswers = documentSnapshot.get("leftAnswers") as! [Int]
                   let swipeName = documentSnapshot.get("leftName") as! String
                   let swipeAnswersToOwnQuestions = documentSnapshot.get("leftAnswersToMyOwn") as! [Int]
                   
                   self.db.collection("users_v2").document(swipedUserId).getDocument { document, error in
                       guard let document = document, error == nil else {
                           print("error setting matches my own answers")
                           return
                       }
                       let userSwipingOnOwnAnswers = document.get("ownAnswers") as! [Int]
                       self.db.collection("matches").document(self.getMatchId(userId1: swipedUserId, userId2: usedId))
                           .setData([
                               "usersMatched": [swipedUserId, usedId],
                               "swipeAnswers" : swipeAnswers,
                               "swipeQuestions" : swipeQuestions,
                               "swipeLeftExamples" : swipeLeftExamples,
                               "swipeRightExamples" : swipeRightExamples,
                               "swipeAnswersToOwnQuestions" : swipeAnswersToOwnQuestions,
                               "swipeName" : swipeName,
                               "usersName" : name,
                               "userAnswers" : chosenAnswers,
                               "userQuestions" : chosenQuestions,
                               "userLeftExamples" : leftQuestions,
                               "userRightExamples" : rightQuestions,
                               "userSwipingOnOwnAnswers" : userSwipingOnOwnAnswers,
                               "timestamp": FieldValue.serverTimestamp(),
                               "isGroupMatch":teamSwipe
//                               "firstMessage" : false
                           ])
                   }


               }
               onMatch()

           }
       })
    }

    func fetchNewProfiles(initialFetch : Bool, profiles: [NewUserProfile], onCompletion: @escaping(Result<[NewUserProfile], DomainError>)->()){
        fetchUserProfile(onCompletion: {result in
            switch result{
            case .success(let user):
                var repeatedProfiles : [String] = []
                for profile in profiles {
                    repeatedProfiles.append(profile.userId)
                }
                let excludedUsers = user.liked + user.passed + repeatedProfiles
                self.fetchNewProfiles(initialFetch: initialFetch, profiles: profiles, groupId: user.groupId ?? "",  userLatitude: user.latitude ?? 0, userLongitude: user.longitude ?? 0,  userInteractionPreference: user.interactionPreference, userFormPreference: user.formPreference, maxDistancePreference: user.maxDistancePreference, minYearPreference: user.minYearPreference, maxYearPreference: user.maxYearPreference,  excludedUsers: excludedUsers, onCompletion: onCompletion)
                break
            case .failure(let error):
                onCompletion(.failure(error))
                break
            }
        })
    }
    func fetchGroupNewProfiles(initialFetch : Bool,profiles: [NewUserProfile], groupId: String, onCompletion: @escaping(Result<[NewUserProfile], DomainError>)->()){
        fetchUserProfile(fetchedUserId: groupId, onCompletion: {result in
            switch result{
            case .success(let user):
                
                
                var repeatedProfiles : [String] = []
                for profile in profiles {
                    repeatedProfiles.append(profile.userId)
                }
                let excludedUsers = user.liked + user.passed + repeatedProfiles
             
                self.fetchNewProfiles(initialFetch: initialFetch,profiles: profiles,groupId: user.groupId!, userLatitude: user.latitude ?? 0, userLongitude: user.longitude ?? 0, userInteractionPreference: user.interactionPreference, userFormPreference: user.formPreference, maxDistancePreference: user.maxDistancePreference, minYearPreference: user.minYearPreference, maxYearPreference: user.maxYearPreference,  excludedUsers: excludedUsers, onCompletion: onCompletion)
                break
            case .failure(let error):
                onCompletion(.failure(error))
                break
            }
        })
    }
    func fetchCompltetedProfiles() -> [NewUserProfile] {
        return self.completedFetches 
    }
    func setProfiles(profiles: [NewUserProfile]){
        self.completedFetches = profiles 
    }
//coordinate distance helpers
    func deg2rad(deg:Double) -> Double {
        return deg * Double.pi / 180
    }
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / Double.pi
    }
    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg:lat1)) * sin(deg2rad(deg:lat2)) + cos(deg2rad(deg:lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
//        if (unit == "K") {
//            dist = dist * 1.609344
//        }
//        else if (unit == "N") {
//            dist = dist * 0.8684
        
//        }
        print(dist)
        return dist
    }
    func clearQuery(){
        self.lastDocQuery = nil 
    }
    private func fetchNewProfiles(initialFetch: Bool, profiles: [NewUserProfile], groupId: String, userLatitude: Double, userLongitude: Double,   userInteractionPreference: Int, userFormPreference: Int, maxDistancePreference: Double, minYearPreference: Int, maxYearPreference: Int,  excludedUsers: [String], onCompletion: @escaping(Result<[NewUserProfile], DomainError>)->()){
        
//        var searchQuery = db.collection("users_v2").whereField(FirestoreUser2.CodingKeys.isDiscoverable.rawValue , isEqualTo: true).whereField(FirestoreUser2.CodingKeys.formPreference.rawValue, isEqualTo: userInteractionPreference)
        self.isFetchingMoreDocs = true
               var docQuery: Query!
        
        
//        var searchQuery = db.collection("users_v2").whereField(FirestoreUser2.CodingKeys.isDiscoverable.rawValue , isEqualTo: true).limit(to: 3)
// if this returns nothing then documents are empty
        if profiles.isEmpty && initialFetch{
            print("empty profiles")
            docQuery = db.collection("users_v2").whereField(FirestoreUser2.CodingKeys.isDiscoverable.rawValue , isEqualTo: true).limit(to: 3).order(by: "groupId", descending: true)
            
        } else if let lastDocQuery = self.lastDocQuery {
            print("fetching from last query")
            docQuery = db.collection("users_v2").whereField(FirestoreUser2.CodingKeys.isDiscoverable.rawValue , isEqualTo: true).limit(to: 3).order(by: "groupId", descending: true).start(afterDocument: lastDocQuery)
        }

 
        docQuery.getDocuments(completion: { (snapshot, err) in
            guard let documentSnapshot = snapshot, err == nil else {
                print("failed here")
                onCompletion(.failure(.downloadError))
                return
            }

//            print("making new profile list \(documentSnapshot.documents.count)")
            if documentSnapshot.documents.count == 0 {
                onCompletion(.success([]))
                return
            }
            self.lastDocQuery = documentSnapshot.documents[documentSnapshot.documents.count-1]
            let maxProfilesFetched = documentSnapshot.documents.count

            
            
            var profileList: [NewUserProfile] = []
            var count = 0
            var hasFailed = false
//            var filteredDocumentList = documentSnapshot.documents.filter{ $0.documentID != self.userId && !excludedUsers.contains($0.documentID)}
            
            var filteredDocumentList = groupId == "" ? documentSnapshot.documents.filter{ $0.documentID != self.userId && !excludedUsers.contains($0.documentID)} : documentSnapshot.documents.filter{ $0.documentID != self.userId && !excludedUsers.contains($0.documentID) && $0.documentID != groupId }
//            print("making filtered profile list \(filteredDocumentList.count)")

            if filteredDocumentList.isEmpty{
                
                if maxProfilesFetched == 0 {
                    print("empty filtered list ")
                    onCompletion(.success([]))
                     return
                }else{
//                    print("checking again from query")
//                    self.fetchNewProfiles(initialFetch: false, profiles: profiles, groupId: groupId, userLatitude: userLatitude, userLongitude: userLongitude, userInteractionPreference: userInteractionPreference, userFormPreference: userFormPreference, maxDistancePreference: maxDistancePreference, minYearPreference: minYearPreference, maxYearPreference: maxYearPreference, excludedUsers: excludedUsers, onCompletion: onCompletion)
                    self.fetchNewProfiles(initialFetch: false, profiles: profiles, onCompletion: onCompletion)
                }
                
           
            }

            let maxCount = filteredDocumentList.count
            for document in filteredDocumentList{
//                print("START START")
                let decoder = JSONDecoder()
                var dict = document.data()
                for (key, value) in dict {
                //We need to check if the value is a Date (timestamp) and parse it as a string, since you cant serialize a Date. This might be true for other types you have serverside.
                if let value = value as? Date {
                  let formatter = DateFormatter()
                    dict[key] = formatter.string(from: value)
                   }
                 }
                if let data = try? JSONSerialization.data(withJSONObject: dict, options:[]){
                    let fireUser = try? decoder.decode(FirestoreUser2.self, from: data)
                    let userName = fireUser!.name
                    let userAge = fireUser!.age
                    let userBio = fireUser!.bio
                    let userAmountOfUSers = fireUser!.amountOfUsers
                    let userIsATeam = fireUser!.isATeam
                    let userCollege = fireUser!.college
                    let userOccupation = fireUser!.occupation
                    let userInteractionPreference = fireUser!.interactionPreference
                    let userFormPreference = fireUser!.formPreference
             
                    let userMaxDistancePreference = fireUser!.maxDistancePreference
                    let userMinAgePreference = fireUser!.minYearPreference
                    let userMaxAgePreference = fireUser!.maxYearPreference
                    let userGroupId = fireUser!.groupId
                    let userInterests = fireUser!.interests
                    let answersToGlobalQuestions = fireUser!.answersToGlobalQuestions
                    let ownQuestions = fireUser!.ownQuestions
                    let ownLeftAnswer = fireUser!.ownLeftAnswer
                    let ownRightAnswer = fireUser!.ownRightAnswer
                    let userCity = fireUser!.city
                    print(userName)
                    if userIsATeam {
                        
                        
//                        self.fetchGroupProfilePictures(profileId: document.documentID, onCompletion: { result in
//                            if hasFailed {
//                                print("has failed")
//                                return}
//                            switch result{
//                            case .success(let images):
//                        self.fetchGroupProfile(groupId: userGroupId!) { result in
//                            switch result {
//                            case .success(let group):
////                                print("success fetchihng group in nameandprofilepic")
////                                        let groupNameIds = group.usersInGroup
//                                    self.fetchNamesAndProfilePics(members: group.usersInGroup) { result in
//                                        switch result {
//                                        case .success(let nameAndPic):
////                                            print("Success name and pic appending ")
//                                            profileList.append(
//                                                NewUserProfile(userId: document.documentID, name: userName, age: userAge, bio: userBio, amountOfUsers: userAmountOfUSers, isATeam: userIsATeam, interests: userInterests, college: userCollege, occupation: userOccupation, formPreference: userFormPreference, interactionPreference: userInteractionPreference, maxDistancePreference: userMaxDistancePreference, maxYearPreference: userMaxAgePreference, minYearPreference: userMinAgePreference, answersToGlobalQuestions: answersToGlobalQuestions, ownQuestions: ownQuestions, ownLeftAnswer: ownLeftAnswer,ownRightAnswer: ownRightAnswer, pictures: images, nameAndPic: nameAndPic, city: userCity)
//                                            )
////                                            print("counting here in name and pic ")
//                                            count += 1
//                                            if(count == maxCount){
////                                                self.lastDocQuery = filteredDocumentList[filteredDocumentList.count-1]
//                                                                 self.isFetchingMoreDocs = false
//
//                                                onCompletion(.success(profileList))
//                                                return
//                                            }
////                                            print("BOOM")
//                                            return
//                                        case .failure(let error):
//                                            print("error fetching name and profile pic \(error)")
//                                            count += 1
//                                            if(count == maxCount){
////                                                self.lastDocQuery = filteredDocumentList[filteredDocumentList.count-1]
//                                                                 self.isFetchingMoreDocs = false
//
//                                                onCompletion(.success(profileList))
//                                                return
//                                            }
//
//                                        }
//                                    }
//
//                            case .failure(let error):
//                                print("error retrieving group profile from fetchingprofiles \(error)")
//                                count += 1
//                                if(count == maxCount){
////                                                self.lastDocQuery = filteredDocumentList[filteredDocumentList.count-1]
//                                                     self.isFetchingMoreDocs = false
//
//                                    onCompletion(.success(profileList))
//                                    return
//                                }
//
//                            }
//                        }
//                            case .failure(let error):
//                                print("theres been an error retrieving group profile information ")
//                                count += 1
//                                if(count == maxCount){
////                                                self.lastDocQuery = filteredDocumentList[filteredDocumentList.count-1]
//                                                     self.isFetchingMoreDocs = false
//
//                                    onCompletion(.success(profileList))
//                                    return
//                                }
//
////                                onCompletion(.failure(error))
////                                hasFailed = true
////                                return
//                            }
//                        })
                    }
                    else{
//                        print("HALLO")
                        self.fetchProfilePictures(profileId: document.documentID, onCompletion: { result in
                            if hasFailed {
                                print("has failed")
                                return}
                            switch result{
                            case .success(let images):
//                                print("IMAGE SUCCESS")
                                    profileList.append(
                //                                    NewUserProfile(userId: document.documentID, name: userName, age: userAge, pictures: images)
                                        NewUserProfile(userId: document.documentID, name: userName, age: userAge, bio: userBio, amountOfUsers: userAmountOfUSers, isATeam: userIsATeam, interests: userInterests, college: userCollege, occupation: userOccupation,  formPreference: userFormPreference, interactionPreference: userInteractionPreference, maxDistancePreference: userMaxDistancePreference, maxYearPreference: userMaxAgePreference, minYearPreference: userMinAgePreference, answersToGlobalQuestions: answersToGlobalQuestions, ownQuestions: ownQuestions, ownLeftAnswer: ownLeftAnswer,ownRightAnswer: ownRightAnswer, pictures: images, nameAndPic: [NameAndProfilePic(names: "", pictures: UIImage(), bio:"", answers: [])], city:userCity)
                                    )
                                    count += 1
//                                print("Count \(count)")
//                                print("maxcount \(maxCount)")
                                if(count == maxCount ){
//                                    self.lastDocQuery = filteredDocumentList[filteredDocumentList.count-1]
                                                     self.isFetchingMoreDocs = false

                                    onCompletion(.success(profileList))
                                    return
                                }
//                                print("BAM")
                                return
                            case .failure(let error):
                                print("theres been an error retrieving  profile information \(error)")
                                count += 1
                                if(count == maxCount){
//                                                self.lastDocQuery = filteredDocumentList[filteredDocumentList.count-1]
                                                     self.isFetchingMoreDocs = false

                                    onCompletion(.success(profileList))
                                    return
                                }

//                                onCompletion(.failure(error))
//                                hasFailed = true
//                                return
                            }
                        })
                    }
   
                }
                else{
                    print("failure fetching parsing error in fetch")
                    count += 1
                    if(count == maxCount){
//                                                self.lastDocQuery = filteredDocumentList[filteredDocumentList.count-1]
                                         self.isFetchingMoreDocs = false

                        onCompletion(.success(profileList))
                        return
                    }

                }
            }

        })
    }
     func fetchNamesAndProfilePics(members: [String], onCompletion: @escaping (Result<[NameAndProfilePic],DomainError>)->()){
        
        var nameAndPic : [NameAndProfilePic] = []
        
        var maxCount : Int = members.count
        var count : Int = 0
        for member in members {
            
            fetchMainPicture(profileId: member) { result in
                switch result {
                    case .success(let image):
                    self.fetchOtherUserProfile(fetchedUserId: member) { rsult in
                        switch rsult {
                            case .success(let user):
                            nameAndPic.append(NameAndProfilePic(names: user.name, pictures: image, bio: user.bio, answers:user.answersToGlobalQuestions))
                            count += 1
                            if maxCount == count {
                                onCompletion(.success(nameAndPic))
                                return
                            }
                        case .failure(let error):
                            onCompletion(.failure(error))
                        }
                    }
                    case .failure(_):
                        onCompletion(.failure(.downloadError))

                }
            
            }

            
        }

    }



    func fetchGroupUserPictures(groupId: String, onCompletion: @escaping (Result<[UIImage],DomainError>)->(), onUpdate: @escaping (Result<[UIImage],DomainError>)->()){
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = viewContext
        context.automaticallyMergesChangesFromParent = true
        context.perform {
            let fetchRequest = ProfilePicture.fetchRequest()
            let descriptor = NSSortDescriptor(key: "position", ascending: true)
            fetchRequest.sortDescriptors = [descriptor]
            if let localPictures = try? context.fetch(fetchRequest){
                let imageData = localPictures.compactMap{ $0.picture }
                let images: [UIImage] = imageData.compactMap{ UIImage(data: $0) }
                DispatchQueue.main.async {
                    onCompletion(.success(images))
                    self.checkGroupMetadata(groupId:groupId,localPictures, onUpdate)
                }
            } else{
                DispatchQueue.main.async {
                    onCompletion(.failure(.localfetchingError))
                }
            }
        }
    }
    func fetchUserPictures(onCompletion: @escaping (Result<[UIImage],DomainError>)->(), onUpdate: @escaping (Result<[UIImage],DomainError>)->()){
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = viewContext
        context.automaticallyMergesChangesFromParent = true
        context.perform {
            let fetchRequest = ProfilePicture.fetchRequest()
            let descriptor = NSSortDescriptor(key: "position", ascending: true)
            fetchRequest.sortDescriptors = [descriptor]
            if let localPictures = try? context.fetch(fetchRequest){
                let imageData = localPictures.compactMap{ $0.picture }
                let images: [UIImage] = imageData.compactMap{ UIImage(data: $0) }
                DispatchQueue.main.async {
                    print("images here \(images.count)")
                    onCompletion(.success(images))
                    self.checkMetadata(localPictures, onUpdate)
                }
            } else{
                DispatchQueue.main.async {
                    onCompletion(.failure(.localfetchingError))
                }
            }
        }
    }
    private func fetchMainPicture(profileId: String, onCompletion: @escaping(Result<UIImage, DomainError>)->()){
        let picRef = storage.child("users_v2").child(profileId).child("profile_pic_0.jpg")
        picRef.getData(maxSize: self.IMG_MAX_SIZE) { data, error in
                if error != nil {
                    onCompletion(.failure(.downloadError))
                } else {
                    onCompletion(.success(UIImage(data: data!)!))
                }
        }
    }
    private func fetchMainGroupPicture(profileId: String, onCompletion: @escaping(Result<UIImage, DomainError>)->()){
        let picRef = storage.child("group_v2").child(profileId).child("profile_pic_0.jpg")
        picRef.getData(maxSize: self.IMG_MAX_SIZE) { data, error in
                if error != nil {
                    onCompletion(.failure(.downloadError))
                } else {
                    onCompletion(.success(UIImage(data: data!)!))
                }
        }
    }

     func fetchProfilePictures(profileId: String, onCompletion: @escaping(Result<[UIImage], DomainError>)->()){
        let userRef = storage.child("users_v2").child(profileId)
        userRef.listAll(completion: { (result, error) in
            if error != nil{
                print("error downloading pictures")
                onCompletion(.failure(.downloadError))
                return
            }
            var profilePictures: [UIImage] = []
            var count = 0
            var hasFailed = false
//            for picRef in result.items{
            if result!.items.isEmpty {
                print("no images associated with this account")

                onCompletion(.failure(.downloadError))
                return
            }

            for picRef in result!.items{
                picRef.getData(maxSize: self.IMG_MAX_SIZE) { data, error in
                    if hasFailed {
                        print("has faileed below get data")
                        return

                    }
                    if error != nil {
                        print("fialure to download error")
                        onCompletion(.failure(.downloadError))
                        hasFailed = true
                    } else {
//                        print("profilePictures.append(UIIMageData")
                        profilePictures.append(UIImage(data: data!)!)
                        count += 1
//                        if(count == result.items.count){
                        if(count == result!.items.count){
//                            print("supposed to be complete")
                            onCompletion(.success(profilePictures))
                        }
                    }
                }
            }
        })
    }
    private func fetchGroupProfilePictures(profileId: String, onCompletion: @escaping(Result<[UIImage], DomainError>)->()){

        let userRef = storage.child("group_v2").child(profileId)
        userRef.listAll(completion: { (result, error) in
            if error != nil{
                print("error downloading pictures")
                onCompletion(.failure(.downloadError))
                return
            }
            var profilePictures: [UIImage] = []
            var count = 0
            var hasFailed = false
//            for picRef in result.items{
            if result!.items.isEmpty {
                print("no images associated with this account")
                onCompletion(.failure(.downloadError))
                return
            }

            for picRef in result!.items{
                picRef.getData(maxSize: self.IMG_MAX_SIZE) { data, error in
                    if hasFailed {
                        print("has faileed below get data")
                        return

                    }
                    if error != nil {
                        print("fialure to download error")
                        onCompletion(.failure(.downloadError))
                        hasFailed = true
                    } else {
                        print("profilePictures.append(UIIMageData")
                        profilePictures.append(UIImage(data: data!)!)
                        count += 1
//                        if(count == result.items.count){
                        if(count == result!.items.count){
                            print("supposed to be complete")
                            onCompletion(.success(profilePictures))
                        }
                    }
                }
            }
        })
    }
    //METADATA
    private func checkMetadata(_ localPictures: [ProfilePicture], _ onUpdate: @escaping (Result<[UIImage],DomainError>)->()){

        
        if userId == nil {return}
        let timestamps = localPictures.compactMap{ $0.timestamp }
        let userRef = storage.child("users_v2").child(userId!)
        userRef.listAll(completion: {result, error in
            if error != nil{
                onUpdate(.failure(.downloadError))
                return
            }
            var updatedLocalPictures: [LocalPicture] = []
            var count = 0
            var hasChanged = false
//            for (index, picRef) in result.items.enumerated(){
            for (index, picRef) in result!.items.enumerated(){
                picRef.getMetadata { metadata, error in
                    if error != nil {
                        onUpdate(.failure(.downloadError))
                    } else if let picTimestamp = metadata?.timeCreated{
                            print("This is picRef = \(picRef.name)")
                        if(index < timestamps.count && picTimestamp == timestamps[index]){
                            print("Timestamps are equal, they are the same image")
                            let localPicture = localPictures[index]
                            updatedLocalPictures.append(LocalPicture(data: localPicture.picture, timestamp: picTimestamp, position: localPicture.position))
                            count += 1
                        }else if let timestampIndex = timestamps.firstIndex(of: picTimestamp){

                            print("Timestamp is the timestamp of a picture in another position")
                            let localPicture = localPictures[timestampIndex]
                            updatedLocalPictures.append(LocalPicture(data: localPicture.picture, timestamp: picTimestamp, position: localPicture.position))
                            hasChanged = true
                            count += 1
                        }else{
                            print("Timestamp not found, downloading the picture...")

                            picRef.getData(maxSize: self.IMG_MAX_SIZE) { data, error in
                              if error != nil {
                                  onUpdate(.failure(.downloadError))
                              } else {
                                  hasChanged = true
                                  updatedLocalPictures.append(LocalPicture(data: data, timestamp: picTimestamp, position: Int16(index)))
                                  count += 1

                                  //PERFORM UPDATE
//                                  if(count == result.items.count){

                                  if(count == result!.items.count){
                                      self.performImageUpdate(updatedLocalPictures, onUpdate)
                                  }
                              }
                            }
                        }

                        //PERFORM UPDATE
//                        if(count == result!.items.count && hasChanged){
                        if(count == result!.items.count && hasChanged){
                            self.performImageUpdate(updatedLocalPictures, onUpdate)
                        }
                    } else {
                        onUpdate(.failure(.downloadError))
                    }
                }
            }
        })
    }
    private func checkGroupMetadata(groupId: String, _ localPictures: [ProfilePicture], _ onUpdate: @escaping (Result<[UIImage],DomainError>)->()){

        if userId == nil {return}
        let timestamps = localPictures.compactMap{ $0.timestamp }
        let userRef = storage.child("group_v2").child(userId!)
        userRef.listAll(completion: {result, error in
            if error != nil{
                onUpdate(.failure(.downloadError))
                return
            }
            var updatedLocalPictures: [LocalPicture] = []
            var count = 0
            var hasChanged = false
//            for (index, picRef) in result.items.enumerated(){
            for (index, picRef) in result!.items.enumerated(){
                picRef.getMetadata { metadata, error in
                    if error != nil {
                        onUpdate(.failure(.downloadError))
                    } else if let picTimestamp = metadata?.timeCreated{
                            print("This is picRef = \(picRef.name)")
                        if(index < timestamps.count && picTimestamp == timestamps[index]){
                            print("Timestamps are equal, they are the same image")
                            let localPicture = localPictures[index]
                            updatedLocalPictures.append(LocalPicture(data: localPicture.picture, timestamp: picTimestamp, position: localPicture.position))
                            count += 1
                        }else if let timestampIndex = timestamps.firstIndex(of: picTimestamp){

                            print("Timestamp is the timestamp of a picture in another position")
                            let localPicture = localPictures[timestampIndex]
                            updatedLocalPictures.append(LocalPicture(data: localPicture.picture, timestamp: picTimestamp, position: localPicture.position))
                            hasChanged = true
                            count += 1
                        }else{
                            print("Timestamp not found, downloading the picture...")

                            picRef.getData(maxSize: self.IMG_MAX_SIZE) { data, error in
                              if error != nil {
                                  onUpdate(.failure(.downloadError))
                              } else {
                                  hasChanged = true
                                  updatedLocalPictures.append(LocalPicture(data: data, timestamp: picTimestamp, position: Int16(index)))
                                  count += 1

                                  //PERFORM UPDATE
//                                  if(count == result.items.count){

                                  if(count == result!.items.count){
                                      self.performImageUpdate(updatedLocalPictures, onUpdate)
                                  }
                              }
                            }
                        }

                        //PERFORM UPDATE
//                        if(count == result!.items.count && hasChanged){
                        if(count == result!.items.count && hasChanged){
                            self.performImageUpdate(updatedLocalPictures, onUpdate)
                        }
                    } else {
                        onUpdate(.failure(.downloadError))
                    }
                }
            }
        })
    }
    //FILTERS AND UPDSTING FETCHING PROFILES BASED ON FILTERS
    func updateDataFilters(modified profileFields: [String: Any], onCompletion: @escaping (Result<Void, DomainError>)->()){
        
        
        let ref = db.collection("users_v2").document(userId!).collection("filters_v1").document(userId!)
        
        
        ref.updateData(profileFields) { err in
            if err != nil {
                onCompletion(.failure(.uploadError))
            } else {
                print("Filter Document successfully updated")
                onCompletion(.success(()))
            }
        }
    }




    // DEALING WITH GROUP SETTINGS

    func fetchGroupProfile(onCompletion: @escaping (Result<FirestoreGroup, DomainError>) ->()){
        if userId == nil{
            return
        }
        let docRef = db.collection("users_v2").document(userId!)
//        let groupRef = collection("group_v2").document()

        docRef.getDocument { document, error in
        let decoder = JSONDecoder()
        var dict = document!.data()
//
        for (key, value) in dict! {
         if let value = value as? Date {
           let formatter = DateFormatter()
             dict?[key] = formatter.string(from: value)
            }
          }

        let data = try? JSONSerialization.data(withJSONObject: dict!, options:[])
        do{
            let fireUser = try decoder.decode(FirestoreUser2.self, from: data!)
            let groupId = fireUser.groupId
            if groupId == "" {
                return
//                onCompletion(.failure(.downloadError))
            }

            let groupRef = self.db.collection("group_v2").document(groupId!)
            groupRef.getDocument {(doc, error) in

            if let document = doc, document.exists {

                let groupDict = document.data()

                for (key, value) in groupDict! {
                 if let value = value as? Date {
                   let formatter = DateFormatter()
                     dict?[key] = formatter.string(from: value)
                    }
                  }
                let groupData = try? JSONSerialization.data(withJSONObject: groupDict!, options:[])
                do{
                    let fireGroup = try? decoder.decode(FirestoreGroup.self, from: groupData!)

                    let fireGroupId = fireGroup?.id
                    print("FiregroupId: \(String(describing: fireGroupId))")
                    onCompletion(.success(fireGroup!))
                }



                }
                else{
                    print("no fetching group profile error")
                    onCompletion(.failure(.downloadError))
                }
            }


        }
        catch{
            print(error)
            return
        }
        return

        }
    }
    func fetchGroupProfile(groupId: String, onCompletion: @escaping (Result<FirebaseTeam, DomainError>) ->()){
        print("group id: \(groupId)")
       
        let groupRef = self.db.collection("group_v2").document(groupId)
        groupRef.getDocument {(doc, error) in

        if let document = doc, document.exists {

            let decoder = JSONDecoder()
            var dict = document.data()
            for (key, value) in dict! {

             if let value = value as? Timestamp {
                 let formatter = DateFormatter()
                 print("value of time stamp \(value)")
                 formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                 let newValue = value.dateValue()
                 dict?[key] = formatter.string(from: newValue)

                }
              }
            let data = try? JSONSerialization.data(withJSONObject: dict!, options:[])
            do{
                let fireUser = try decoder.decode(FirebaseTeam.self, from: data!)
                print("fire user inside fetch group profile")
                onCompletion(.success(fireUser))
            }
            catch{
                print("ERROR PARSING USER 3")
                print(error)
                onCompletion(.failure(.parsingError))
                }


            }
            else{
                print("no fetching group profile error")
                onCompletion(.failure(.downloadError))
            }
        }


    }


        func updateUsersGroup(sendId: String,groupId: String, onCompletion: @escaping(Result<Void,DomainError>)->()){

            let userRef = db.collection("users_v2").document(sendId)
            userRef.getDocument(completion: { [weak self] doc, error in
                    guard error == nil else {
                        print("error", error ?? "")
                        onCompletion(.failure(.downloadError))
                        return
                    }

                    if let document = doc, document.exists {
                        print("User not in squad and updating")
                        userRef.updateData([
                            "groupId" : groupId
                        ])

                        self!.deleteRequest(sendId:sendId, groupId: groupId, onCompletion: onCompletion)

                    }
                    else{
                        print("This user no longer exists")
                        onCompletion(.failure(.downloadError))
                        return
                    }
                })
            let reqRef = db.collection("requests_v1").document("\(groupId)\(sendId)")

            reqRef.updateData([

                "isFriends":true

            ])


        }





//    func updateGroupProfile(groupId: String, modified profileFields: [String: Any], onCompletion: @escaping (Result<Void,DomainError>) -> () ){
//        let ref = db.collection("group_v2").document(groupId)
//        ref.updateData(profileFields) { err in
//            if err != nil {
//                onCompletion(.failure(.uploadError))
//            } else {
//                print("Group Document successfully updated")
//                self.storeGroupProfileInLocal(onCompletion: onCompletion)
//            }
//        }
//    }
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

    //REQUESTS TO JOIN GROUP
    //addd functions to only allow user to send one request, and if they send a request they cant create a grouop until they cancel their request
//    func sendJoinRequest(groupId: String, onCompletion: @escaping(Result<Void,DomainError>) -> () ){
//
//        if(groupId.count != 10){
//            onCompletion(.failure(.uploadError))
//            return
//        }
//
//        let groupRef = db.collection("group_v2").document(groupId)
//        groupRef.getDocument { [self](doc, error) in
//
//            guard error == nil else {
//                print("error", error ?? "")
//                onCompletion(.failure(.downloadError))
//                return
//            }
//
//            if let document = doc, document.exists {
//
//                if self.userId == nil {
//                    onCompletion(.failure(.localfetchingError))
//                    return
//                }
//
//                self.fetchUserProfile { result in
//
//                    switch (result){
//                    case .success(let user):
//                        print("success fetching users name, updating request")
//                        let name = user.name
//                        let sendingRequestId = self.userId!
//                        let firerequest = FirestoreRequest(groupId: groupId, sendingRequestId: sendingRequestId, nameOfSender: name, isFriends: false)
//                        self.db.collection("requests_v1").document("\(groupId)\(sendingRequestId)").setData(firerequest.dictionary)
//                        onCompletion(.success(()))
//                        return
//
//
//                    case .failure(let error):
//                        onCompletion(.failure(error))
//                        break
//                    }
//
//                }
//
//            }
//            else{
//                onCompletion(.failure(.downloadError))
//                print("Group ID does not exist or failed downloading from server")
//            }
//
//        }
//
//    }

    func fetchRequests(groupId: String, onCompletion: @escaping (Result<[RequestModel], DomainError>) -> ()){
        db.collection("requests_v1").whereField("groupId", isEqualTo: groupId).whereField("isFriends", isEqualTo: false).getDocuments { doc, error in
            guard let documentSnapshot = doc, error == nil else{
                onCompletion(.failure(.downloadError))
                return
            }
            var requestList: [RequestModel] = []
            let maxCount = documentSnapshot.documents.count
            var hasFailed = false
            var count = 0

            if(maxCount == 0){
                print("No one has requested to join")
                onCompletion(.success([]))
            }
            for document in documentSnapshot.documents{
                if hasFailed{break}
                let decoder = JSONDecoder()
                let dict = document.data()
                if let data = try? JSONSerialization.data(withJSONObject: dict, options:[]){

                    do {

                        let request = try? decoder.decode(FirestoreRequest.self, from: data)
                        let requestName = request!.nameOfSender
                        let requestId = request!.sendingRequestId

//                        requestList.append(RequestModel(id: document.documentID, sendingRequestId: requestId, nameOfSender: requestName,groupId: groupId))

                        count += 1
                        if count == maxCount {
                            onCompletion(.success(requestList))
                        }
                    }
                }
            }
        }
    }

    func checkIfCanAcceptRequest(sendName: String, sendId: String, groupId:String, onCompletion:@escaping (Result<Void,DomainError>)->()){

        let userRef = db.collection("users_v2").document(sendId)
        userRef.getDocument {(doc, error) in
            guard error == nil else {
                print("error", error ?? "")
                onCompletion(.failure(.downloadError))
                return
            }
        if let document = doc, document.exists {
            let groupDict = document.data()

            if (groupDict!["groupId"] as! String != ""){

                print("Accepting member is already in a group")
                onCompletion(.failure(.uploadError))
                return

                }
            else{
                self.acceptRequest(sendName: sendName, sendId: sendId, groupId: groupId, onCompletion: onCompletion)
            }

            }
        }



    }
    func acceptRequest(sendName: String, sendId: String, groupId: String, onCompletion:@escaping(Result<Void,DomainError>)->()){



        let groupRef = db.collection("group_v2").document(groupId)
        groupRef.getDocument { doc, error in

                guard error == nil else {
                    print("error", error ?? "")
                    onCompletion(.failure(.downloadError))
                    return
                }

            if let document = doc, document.exists {
                self.fetchGroupProfile { result in

                    switch (result){
                    case .success(let group):
                        if group.usersInGroup.count >= 6 {
                            print("more than 6 users in group")
                            onCompletion(.failure(.uploadError))
                            return
                        }
                        else{
                            print("sufficien space in group")
                            var newModel = group.usersInGroup
                            newModel.append(sendId)
                            var newTeamNames = group.teamNames
                            newTeamNames.append(sendName)

                            groupRef.updateData([
                                 "usersInGroup" : newModel,
                                 "teamNames" : newTeamNames
                            ])
                            print("updating users group info")

                            self.updateUsersGroup(sendId: sendId, groupId: groupId, onCompletion: onCompletion)


                        }
                    default:
                        print("Failure with uploading as case")
                        onCompletion(.failure(.uploadError))
                        return
                    }
                }
            }

        }
    }

    func deleteRequest(sendId: String, groupId: String, onCompletion: @escaping(Result<Void,DomainError>)->()){
        print("about to delete")

        db.collection("requests_v1").document("\(groupId)\(sendId)").delete()

        print("maybe delete")
        onCompletion(.success(()))

    }
        func fetchGroupFromRequest(onCompletion:@escaping(Result<String,DomainError>)->()){

            if userId != nil {
                let req = db.collection("requests_v1").whereField("sendingRequestId", isEqualTo: userId!)
                req.getDocuments(completion: {doc, err in
                    guard let documentSnapshot = doc, err == nil else{
                        onCompletion(.failure(.downloadError))
                        return
                    }




                })

            }
            else{

            }

    }


    //DISCOVERABLE MODE
    func updateDiscoverableMode(choice: Bool, groupId:String, onCompletion:@escaping(Result<Void,DomainError>)->()){

        let groupRef = db.collection("group_v2").document(groupId)

        if choice == false {
            print("Changing isDiscoverable in users")
            db.collection("users_v2").document(groupId).updateData([
                "isDiscoverable" : false
            ])
        }
        print("In update discoverable \(choice)")
        groupRef.updateData([
            "isPartOfSwipe" : choice
        ])
        { err in
            if err != nil {
                onCompletion(.failure(.uploadError))
            } else {
                print("Document successfully updated")
                onCompletion(.success(()))
            }
        }
    }

    func checkIfGroupHasUserVersion(groupId: String, onCompletion:@escaping (Result<Bool,DomainError>)->()){

        db.collection("users_v2").document(groupId).getDocument(completion: { doc, err in

            if err != nil {
                print("ERROR IN CHECK IF GROUP HAS USER VERSION")
                onCompletion(.failure(.downloadError))
            }

                if let document = doc, document.exists {
                    onCompletion(.success(true))
                }
                else{
                    onCompletion(.success(false))

                }


        })



    }
    
    func shareTapped(_ sender: String, onComplete: @escaping(URL)->()){
        let groupId = sender
        print("sender: \(sender)")

        
        var components = URLComponents()
        components.scheme = "https"
        
        components.host = "lovol.page.link"

        components.path = "/invite"
        print("group id from share tap \(groupId)")
        let groupIDQueryItem = URLQueryItem(name: "groupID", value: groupId)
        components.queryItems = [groupIDQueryItem]
        print("link with groupID: \(components.url?.absoluteString)")

        guard let linkParameter = components.url else {return }
        
        print("I am sharing \(linkParameter.absoluteString)")
        
        guard let shareLink = DynamicLinkComponents.init(link:linkParameter, domainURIPrefix: "https://lovol.page.link/invite") else{
            print("Could not create FDL COmponents")
            return
        }
        
//        let options = DynamicLinkComponentsOptions()
//         options.lifetime = 3600
//         shareLink.options = options

        
        if let myBundleId = Bundle.main.bundleIdentifier{
            shareLink.iOSParameters = DynamicLinkIOSParameters(bundleID: myBundleId)

        }
//        shareLink.iOSParameters?.appStoreID = "1663381201"
        shareLink.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        shareLink.socialMetaTagParameters?.title = "Download Lovol"
        shareLink.socialMetaTagParameters?.descriptionText = "Finally, an app to find inspiration on what to do with your friends all while winning points for a chance to qualify for a live gameshow where you and your team can win money"
//        shareLink.socialMetaTagParameters?.imageURL = "logo"
        
        guard let longURL = shareLink.url else {return}
        print("long url \(longURL)")
        onComplete(longURL)

//        shareLink.shorten { url, warnings, error in
//            if let error = error {
//                print("there has been an error shortening url \(error)")
//                return
//            }
//            if let warnings = warnings {
//                for warning in warnings {
//                    print("warnign \(warning)")
//                }
//            }
//            guard let url = url else {return}
//            print("Short url \(url.absoluteString)")
////            self.showShareSheet(url: url)
//
//        }


    }
//    func showShareSheet(url:URL){
//        let promoText = "Check THis out"
//        let activityVC = UIActivityViewController(activityItems: [promoText, url], applicationActivities: nil)
////        self.present(activityVC, animated: true )
//    }


    



}

struct LocalPicture{
    var data: Data? = nil
    var timestamp: Date? = nil
    var position: Int16 = 0
}

struct LocalGroupPicture{
    var data: Data? = nil
    var timestamp: Date? = nil
    var position: Int16 = 0
}
