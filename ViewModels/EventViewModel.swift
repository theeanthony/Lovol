//
//  EventViewModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 12/12/22.
//


import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI
import CoreData
import simd
import FirebaseStorage
import CoreLocation

class EventViewModel: NSObject, ObservableObject{
    private let IMG_MAX_SIZE: Int64 = 10 * 1024 * 1024
    private let viewContext = PersistenceController.shared.container.viewContext
    private let profileViewModel : ProfilesViewModel = ProfilesViewModel()
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()

    private var lastDocQuery: DocumentSnapshot!
    @Published var isFetchingMoreDocs: Bool = false
    
    private var completedEvents : [FetchedEvent] = []
    
    private var letLiveEventModel : LiveEventModel = LiveEventModel(startTime: Date(), isActive: false, videoURL: "", seconds: 0, beginingTime: Date(), prize: "1", season: "0", isSelection: false)
    
    private let userId: String? = Auth.auth().currentUser?.uid

    func updateLiveStatusLocal(onCompletion:@escaping (Result<Void,DomainError>)->()) {
        
        checkLiveStatus { result in
            switch result {
            case .success(let event):
                self.letLiveEventModel = event
                onCompletion(.success(()))
                return
            case .failure(let error):
                onCompletion(.failure(error))
                return
            }
        }
    }
    func fetchLiveEvent()->LiveEventModel{
        return letLiveEventModel
    }
    func fetchRSVPSForHost(id:String,onCompletion:@escaping(Result<[String],DomainError>)->()){
        let eventRef = db.collection("hosted_events_v1").document(id).getDocument { document, error in
            guard let document = document, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            let teamsGoing = document.get("groupIDS") as! [String]
            
            onCompletion(.success(teamsGoing))
            return
        }
            
            
        
    }
    func fetchSingleHostEvent(id:String,onCompletion: @escaping (Result<EventModel,DomainError>)->()){
        
        let eventRef = db.collection("hosted_events_v1").document(id)
        
        eventRef.getDocument { document, error in
            guard let document = document, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            let decoder = JSONDecoder()
            var dict = document.data()
//                for (key, value) in dict {
//                    if let value = value as? Date {
//                        let formatter = DateFormatter()
//                        dict[key] = formatter.string(from:value)
//                    }
//                }
            
            let data = try? JSONSerialization.data(withJSONObject: dict, options:[])
            do{
                let event = try decoder.decode(HostEvent.self, from: data!)

                    let groupIDS = document.get("groupIDS") as! [String]
                    let totalRSVP : Int = groupIDS.count
                    let eventTime = document.get("eventTime") as! Int
                    let eventCost = document.get("eventCost") as! Int
                    let eventPoints = document.get("eventPoints") as! Int
                    let eventModel : EventModel = EventModel(id: event.eventId, eventName: event.eventName, eventDescription: event.eventDescription, eventRules: event.eventRules, eventAverageCost: eventCost, eventTime: eventTime, eventPoints: eventPoints, eventType: "Local", eventMonth: event.eventMonth, eventURL: event.photoURL, eventOfferings: event.eventOfferings, eventTips: event.eventTips, eventTags: event.eventTags, isTemp: true, eventReviewPercentage: 0, eventTotalReviews: 0, eventLocation: true, long: event.eventLongCoord, lat: event.eventLatCoord, distance: 0, totalRSVP: totalRSVP, startingTime: event.eventStartTime, endingTime: event.eventEndTime, note: "", groupIDS: groupIDS, didIRSVP: false, lastReview: "", lastReviewName: "", lastReviewDate: "", lastReviewScore: 0, address: event.eventCityName)
                    
                    onCompletion(.success(eventModel))
                    return

            }
            catch{
                print("error parsing this hosted event")
                onCompletion(.failure(.parsingError))
                return
        
            }
        
                
   

        }
  
    }
    func fetchSingleEvent(id:String,onCompletion: @escaping (Result<EventModel,DomainError>)->()){
        print("fetching")
        
        let eventRef = db.collection("events_v1").document(id)
        
        eventRef.getDocument { document, error in
            guard let document = document, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if document.exists {
                
                let address = document.get("address") as! String
                let eventId = document.get("eventId") as! String
                let eventDescription = document.get("eventDescription") as! String
//                let eventLocation = document.get("eventLocation") as! String
      
                let eventName = document.get("eventName") as! String
                let eventPoints = document.get("eventPoints") as! Int
                let eventType = document.get("eventType") as! String
                let eventAverageCost = document.get("eventAverageCost") as! Int
                let eventTime = document.get("eventTime") as! Int
                let eventRules = document.get("eventRules") as! String
                let eventMonth = document.get("eventMonth") as! String
                let eventURL = document.get("eventURL") as! String
                let eventOfferings = document.get("eventOfferings") as! String
                let eventTips = document.get("eventTips") as! String
                let eventTags = document.get("eventTags") as! [String]
                let eventIsTemp = document.get("isTempEvent") as! Bool
                
                let eventReviewPercentage = document.get("eventReviewPercentage") as! Double
                let eventTotalReviews = document.get("eventTotalReviews") as! Int
                
                let eventLocation = document.get("eventLocation") as! Bool
                let eventLong = document.get("long") as! Double
                let eventLat = document.get("lat") as! Double
                
                let lastReview = document.get("lastReview") as! String
                let lastReviewName = document.get("lastReviewName") as! String
                let lastReviewDate = document.get("lastReviewDate") as! String
                let lastReviewScore = document.get("lastReviewScore") as! Int
                onCompletion(.success(EventModel(id: eventId, eventName: eventName, eventDescription: eventDescription, eventRules: eventRules,  eventAverageCost: eventAverageCost, eventTime: eventTime, eventPoints: eventPoints, eventType: eventType, eventMonth: eventMonth, eventURL: eventURL, eventOfferings: eventOfferings, eventTips: eventTips, eventTags: eventTags, isTemp: eventIsTemp, eventReviewPercentage: eventReviewPercentage, eventTotalReviews: eventTotalReviews,eventLocation: eventLocation,long:eventLong,lat:eventLat, lastReview: lastReview,lastReviewName: lastReviewName,lastReviewDate: lastReviewDate, lastReviewScore: lastReviewScore, address: address)))
            }
            else{
                print("document does not exist")
                onCompletion(.failure(.downloadError))
                return
            }
        }
            
               

        
    }
    func fetchHostedEvents(groupId:String,locationSet:Bool,long:Double,lat:Double, alliances:[String],onCompletion:@escaping(Result<[EventModel],DomainError>)->()){
        
        let hostRef = db.collection("hosted_events_v1").whereField("isActive", isEqualTo: true)
        
        hostRef.getDocuments { query, error in
            guard let documents = query , error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            var count = 0
            let maxCount = documents.documents.count
            
            if maxCount == 0 {
                onCompletion(.success([]))
                return
            }
            
            var events : [EventModel] = []
            let decoder = JSONDecoder()

            for document in documents.documents {
                var dict = document.data()
                for (key, value) in dict {
                    if let value = value as? Date {
                        let formatter = DateFormatter()
                        dict[key] = formatter.string(from:value)
                    }
                }
                let data = try? JSONSerialization.data(withJSONObject: dict, options:[])
                do{
                    let event = try decoder.decode(HostEvent.self, from: data!)
                    
                    if event.eventEndTime < Date() {
                        self.updateEventStatus(id:event.eventId)
                    }
                    else{
                        
                        let distance = self.distance(lat1: event.eventLatCoord, lon1: event.eventLongCoord, lat2: lat, lon2: long)
                        let groupIDS = document.get("groupIDS") as! [String]
                        let totalRSVP : Int = groupIDS.count
                        let eventTime = document.get("eventTime") as! Int
                        let eventCost = document.get("eventCost") as! Int
                        let eventPoints = document.get("eventPoints") as! Int
                        let eventModel : EventModel = EventModel(id: event.eventId, eventName: event.eventName, eventDescription: event.eventDescription, eventRules: event.eventRules, eventAverageCost: eventCost, eventTime: eventTime, eventPoints: eventPoints, eventType: "Local", eventMonth: event.eventMonth, eventURL: event.photoURL, eventOfferings: event.eventOfferings, eventTips: event.eventTips, eventTags: event.eventTags, isTemp: true, eventReviewPercentage: 0, eventTotalReviews: 0, eventLocation: true, long: event.eventLongCoord, lat: event.eventLatCoord, distance: distance, totalRSVP: totalRSVP, startingTime: event.eventStartTime, endingTime: event.eventEndTime, note: "", groupIDS: groupIDS, didIRSVP: false, lastReview: "", lastReviewName: "", lastReviewDate: "", lastReviewScore: 0, address: event.eventCityName)
                        events.append(eventModel)
                    }
                    
                    
                    count += 1
                    
                    if maxCount == count {
                        onCompletion(.success(events))
                        return
                    }
                    
            

                }
                catch{
                    print("error parsing this hosted event")
                    count += 1
                    if maxCount == count {
                        onCompletion(.success(events))
                        return
                    }
            
                }
                
                
                
            }
        }
        
    }
    private func updateEventStatus(id:String){
        
    }
    
    func fetchEvents(groupId:String, locationSet: Bool, long:Double,lat:Double,onCompletion: @escaping (Result<[EventModel],DomainError>)->()){
        
        if locationSet {
            self.fetchLocationEvents(groupId:groupId,long: long, lat: lat, onCompletion: onCompletion)
            return
        }
        
        var sponsoredRef = db.collection("events_v1").whereField("isActive",isEqualTo: true)
        sponsoredRef = db.collection("events_v1").whereField("eventLocation",isEqualTo: false)
        
     
        
        sponsoredRef.getDocuments(completion: { (snapshot, err) in
            guard let documentSnapshot = snapshot, err == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if documentSnapshot.isEmpty{
                onCompletion(.success([]))
                return
            }
//            let maxCount = documentSnapshot.count
            var events : [EventModel] = []
            print("in documents")
            
            for document in documentSnapshot.documents{
                
            
                let eventId = document.get("eventId") as! String
                let eventDescription = document.get("eventDescription") as! String
//                let eventLocation = document.get("eventLocation") as! String
      
                let eventName = document.get("eventName") as! String
                let eventPoints = document.get("eventPoints") as! Int
                let eventType = document.get("eventType") as! String
                let eventAverageCost = document.get("eventAverageCost") as! Int
                let eventTime = document.get("eventTime") as! Int
                let eventRules = document.get("eventRules") as! String
                let eventMonth = document.get("eventMonth") as! String
                let eventURL = document.get("eventURL") as! String
                let eventOfferings = document.get("eventOfferings") as! String
                let eventTips = document.get("eventTips") as! String
                let eventTags = document.get("eventTags") as! [String]
                let eventIsTemp = document.get("isTempEvent") as! Bool
                
                let eventReviewPercentage = document.get("eventReviewPercentage") as! Double
                let eventTotalReviews = document.get("eventTotalReviews") as! Int
                
                let eventLocation = document.get("eventLocation") as! Bool
                let eventLong = document.get("long") as! Double
                let eventLat = document.get("lat") as! Double
                
                let lastReview = document.get("lastReview") as! String
                let lastReviewName = document.get("lastReviewName") as! String
                let lastReviewDate = document.get("lastReviewDate") as! String
                let lastReviewScore = document.get("lastReviewScore") as! Int

//                let reviewDate = lastReviewDate.dateValue()
                
//                let distance = self.distance(lat1: eventLat, lon1: eventLong, lat2: lat, lon2: long)
                
//                print("distance \(distance)")

//
                if !locationSet && !eventIsTemp{
                    print("Event does not have location sent or event is temp")
                    let event : EventModel = EventModel(id: eventId, eventName: eventName, eventDescription: eventDescription, eventRules: eventRules,  eventAverageCost: eventAverageCost, eventTime: eventTime, eventPoints: eventPoints, eventType: eventType, eventMonth: eventMonth, eventURL: eventURL, eventOfferings: eventOfferings, eventTips: eventTips, eventTags: eventTags, isTemp: eventIsTemp, eventReviewPercentage: eventReviewPercentage, eventTotalReviews: eventTotalReviews,eventLocation: eventLocation,long:eventLong,lat:eventLat, lastReview: lastReview,lastReviewName: lastReviewName,lastReviewDate: lastReviewDate, lastReviewScore: lastReviewScore, address: "")
                    
              
                    
                    events.append(event)
                }
         
            }
     
            onCompletion(.success(events))
            
            
            
        })
        
    }
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
    func fetchLocationEvents(groupId:String, long:Double,lat:Double, onCompletion: @escaping (Result<[EventModel],DomainError>)->()){
        print("fetching")
        
//        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
//        let radiusInM: Double = 20 * 1000
        
    
        
        let sponsoredRef = db.collection("events_v1").whereField("isActive", isEqualTo: true)
        
        sponsoredRef.getDocuments(completion: { (snapshot, err) in
            guard let documentSnapshot = snapshot, err == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if documentSnapshot.isEmpty{
                onCompletion(.success([]))
                return
            }
//            let maxCount = documentSnapshot.count
            var events : [EventModel] = []
            print("in documents")
            var count = 0
            let maxCount = documentSnapshot.count
            
            for document in documentSnapshot.documents{
                
                let eventLong = document.get("long") as! Double
                let eventLat = document.get("lat") as! Double
                
                print("long and lats being commpared are \(long) and \(eventLong) ,, \(lat) and \(eventLat)")
                
                let distance = self.distance(lat1: eventLat, lon1: eventLong, lat2: lat, lon2: long)
                
                print("distance \(distance)")
                
                
                
                let eventId = document.get("eventId") as! String
                let eventDescription = document.get("eventDescription") as! String
//                let eventLocation = document.get("eventLocation") as! String
                let address = document.get("address") as! String

                let eventName = document.get("eventName") as! String
                let eventPoints = document.get("eventPoints") as! Int
                let eventType = document.get("eventType") as! String
                let eventAverageCost = document.get("eventAverageCost") as! Int
                let eventTime = document.get("eventTime") as! Int
                let eventRules = document.get("eventRules") as! String
                let eventMonth = document.get("eventMonth") as! String
                let eventURL = document.get("eventURL") as! String
                let eventOfferings = document.get("eventOfferings") as! String
                let eventTips = document.get("eventTips") as! String
                let eventTags = document.get("eventTags") as! [String]
                let eventIsTemp = document.get("isTempEvent") as! Bool
                
                let eventReviewPercentage = document.get("eventReviewPercentage") as! Double
                let eventTotalReviews = document.get("eventTotalReviews") as! Int
                
                let eventLocation = document.get("eventLocation") as! Bool
                let lastReview = document.get("lastReview") as! String
                let lastReviewName = document.get("lastReviewName") as! String
                let lastReviewDate = document.get("lastReviewDate") as! String
//                let lastReviewDate = lastlastReviewDate.dateValue()
                let lastReviewScore = document.get("lastReviewScore") as! Int

                //perhaps separate these two? 
                if eventIsTemp {
                    
                    self.db.collection("events_v1").document(document.documentID).collection("temporary_event").document(document.documentID).getDocument { doc, error in
                        guard let doc = doc , error == nil else {
                            let event : EventModel = EventModel(id: eventId, eventName: eventName, eventDescription: eventDescription, eventRules: eventRules,  eventAverageCost: eventAverageCost, eventTime: eventTime, eventPoints: eventPoints, eventType: eventType, eventMonth: eventMonth, eventURL: eventURL, eventOfferings: eventOfferings, eventTips: eventTips, eventTags: eventTags, isTemp: eventIsTemp, eventReviewPercentage: eventReviewPercentage, eventTotalReviews: eventTotalReviews,eventLocation: eventLocation,long:eventLong,lat:eventLat, distance:distance, lastReview: lastReview,lastReviewName: lastReviewName,lastReviewDate: lastReviewDate, lastReviewScore: lastReviewScore, address: address)
                            
                            events.append(event)
                            return
                        }
                        
                        let totalRSVPs = doc.get("totalRSVPs") as! Int
                        let sTime = doc.get("startTime") as! Timestamp
                        let startTime = sTime.dateValue()
                        let eTime = doc.get("endTime") as! Timestamp
                        let endTime = eTime.dateValue()

                        let groupIDs = doc.get("groupsRSVP") as! [String]
                        
                        let note = doc.get("note") as! String
                        
                        
                        let didIRSVP = groupIDs.contains(groupId)
                        
                        print("note \(note)")
                        let event : EventModel = EventModel(id: eventId, eventName: eventName, eventDescription: eventDescription, eventRules: eventRules,  eventAverageCost: eventAverageCost, eventTime: eventTime, eventPoints: eventPoints, eventType: eventType, eventMonth: eventMonth, eventURL: eventURL, eventOfferings: eventOfferings, eventTips: eventTips, eventTags: eventTags, isTemp: eventIsTemp, eventReviewPercentage: eventReviewPercentage, eventTotalReviews: eventTotalReviews,eventLocation: eventLocation,long:eventLong,lat:eventLat, distance:distance, totalRSVP: totalRSVPs, startingTime: startTime,endingTime: endTime,note: note,groupIDS: groupIDs,didIRSVP: didIRSVP, lastReview: lastReview,lastReviewName: lastReviewName,lastReviewDate: lastReviewDate, lastReviewScore: lastReviewScore, address: address)
                        events.append(event)
                        count+=1
                        
                        if count == maxCount {
                            onCompletion(.success(events))
                            return
                        }
//                        finishedFetching = true

                    }
                }else{
                    let event : EventModel = EventModel(id: eventId, eventName: eventName, eventDescription: eventDescription, eventRules: eventRules,  eventAverageCost: eventAverageCost, eventTime: eventTime, eventPoints: eventPoints, eventType: eventType, eventMonth: eventMonth, eventURL: eventURL, eventOfferings: eventOfferings, eventTips: eventTips, eventTags: eventTags, isTemp: eventIsTemp, eventReviewPercentage: eventReviewPercentage, eventTotalReviews: eventTotalReviews,eventLocation: eventLocation,long:eventLong,lat:eventLat, distance:distance, lastReview: lastReview,lastReviewName: lastReviewName,lastReviewDate: lastReviewDate, lastReviewScore: lastReviewScore, address: address)
                    events.append(event)
                    count+=1
                    
                    if count == maxCount {
                        onCompletion(.success(events))
                        return
                    }

                    
                }

  


            }
     
            
            
            
        })
        
    }
    func fetchCompletedEvents(onCompletion:@escaping(Result<[[String]],DomainError>)->()) {
        profileViewModel.fetchMember { result in
            switch result{
            case .success(let user):
                let groupId = user.groupId 
                if groupId == "" {
                    print("not in group when fetching events")
                    onCompletion(.success([]))
                    return 
                }
                let groupEventsRef = self.db.collection("group_v2").document(groupId)
                groupEventsRef.collection("group_events_v1").whereField("eventCompleted", isEqualTo: true).getDocuments(completion: { documentSnapShot, error in
                    guard error == nil else {
                        print("error", error ?? "")
                        onCompletion(.failure(.downloadError))
                        return
                    }
                    print("in group")
                    var completedEvents : [[String]] = []
                    var count = 0
                    let maxCount = documentSnapShot?.documents.count
                    if (maxCount == 0 ){
                        onCompletion(.success([]))
                    }
                    for document in documentSnapShot!.documents{
                        let completedId : String = document.get("id") as! String
                        let completedMonth : String = document.get("eventMonth") as! String
                        let completed : [String] = [completedId, completedMonth]
                        completedEvents.append(completed)
                        count += 1
                        if maxCount == count {
                            onCompletion(.success(completedEvents))
                            return
                        }
                    }
                    
                    
                })
            case .failure(let error):
                print("error \(error)")
            }
        }

 
        
        
    }
    func submitEvent(useMultiplier:Bool, isGlobal: Bool, event: EventModel, photo: [UIImage], onCompletion: @escaping (Result<Int,DomainError>)->()){
        
         profileViewModel.fetchMember { result in
             switch result {
                 
             case .success(let user):
                 let groupId = user.groupId
                 if groupId == "" {
                     onCompletion(.failure(.downloadError))
                     return
                 }
                 let groupRef = self.db.collection("group_v2").document(groupId)
                 
                  print("Submitting event")
                 groupRef.collection("group_events_v1").document("\(event.eventMonth)\(event.id)").getDocument { document, error in
                     guard error == nil else {
                         print("error", error ?? "")
                         onCompletion(.failure(.downloadError))
                         return
                     }
                     if let doc = document, doc.exists{
                         print("exsists ")
                         onCompletion(.failure(.uploadError))
                         return
                         
                     }
                     else{
                         print("group events here ")
                         groupRef.collection("group_events_v1").document("\(event.eventMonth)\(event.id)").setData(
                              [
                                  "id" : event.id,
                                  "eventMonth" : event.eventMonth,
                                  "eventName" : event.eventName,
                                  "eventPoints" : event.eventPoints,
                                  "eventType" : event.eventType,
                                  "eventCompleted" : true,
                                  "timestamp" : FieldValue.serverTimestamp(),
                                  "photoURL" : "",
                                  "submittedForPoints" : false
                                 
                                  ])
                         groupRef.getDocument { document, error in
                             guard error == nil else {
                                 print("error", error ?? "")
                                 onCompletion(.failure(.downloadError))
                                 return
                             }
                             
                             let teamMembers : [String] = document!.get("teamMemberIDS") as! [String]
                             let teamMemberTotal = teamMembers.count
                             var doublerPoints : Int = document!.get("multiplier") as! Int
                             let currentPoints : Int = document!.get("teamPoints") as! Int
                             let currentTotalPoitns : Int = document!.get("lifetimeLovolBits") as! Int
                             let currentEvents : Int = document!.get("totalEventsCompleted") as! Int
                             var newPoints : Int = 0
                             if teamMemberTotal >= 5 {
                                 newPoints = event.eventPoints
                             }
                             else if teamMemberTotal >= 3 && teamMemberTotal < 5 {
                                 newPoints = event.eventPoints/2

                             }
                             else if teamMemberTotal == 2{
                                 newPoints = event.eventPoints/4

                             }
                             else{
                                 newPoints = 1

                             }

                             if useMultiplier && doublerPoints > 0{
                                 newPoints *= 2
                                 doublerPoints -= 1
                             }
                             
                             let newCurrentPoints = currentPoints + newPoints
                             let lifetimePoints = newCurrentPoints + currentTotalPoitns
                             let newCurrentEvents = currentEvents + 1
                             groupRef.updateData([
                                 "teamPoints" : newCurrentPoints
                                 ,
                                 "lifetimeLovolBits" : lifetimePoints,
                                 "totalEventsCompleted" : newCurrentEvents,
                                 "multiplier" : doublerPoints
                             ]){ err in
                                 if let err = err {
                                     print("Error updating document: \(err)")
                                     onCompletion(.failure(.uploadError))
                                 }
                             }
                             print("POINTS in submitevent \(newPoints)")

                             self.submitPhoto(points:newPoints,groupId:groupId,isGlobal:isGlobal,event: event, photo: photo, onCompletion: onCompletion)
                         }
                     }
                 }
             case .failure(let error):
                 print("error \(error)")
                 onCompletion(.failure(error))
                 
                 
             }
         }


        
    }
     func checkIfEventAlreadyDone(event:EventModel, onCompletion:@escaping(Result<Bool,DomainError>)->()){
        
        profileViewModel.fetchMember { result in
            switch result{
            case .success(let member):
                let groupId = member.groupId
                if groupId == "" {
                    onCompletion(.success(false))
                    return
                }
                else{
                    self.db.collection("server_v1").document("0").getDocument { doc, error in
                        guard let doc = doc, error == nil else {
                            onCompletion(.failure(.downloadError))
                            return
                        }
                        let season = doc.get("season") as! String
                        
                        let groupRef = self.db.collection("group_v2").document(groupId).collection("group_events_v1").document("\(season)\(event.id)")
                        
                        groupRef.getDocument{
                            document, error in
//                            guard let error = error, error == nil else {
//                                onCompletion(.failure(.downloadError))
//                                return
//                            }
                            if let document = document, document.exists{
                                onCompletion(.success(false))
                                return
                            }
                            else{
                                onCompletion(.success(true))
                                return
                            }
                        }
                    }
                }
            case .failure(let error):
                onCompletion(.failure(.downloadError))
                return
            }
        }

        
    }
    private func submitPhoto(points:Int,groupId:String,isGlobal:Bool,event: EventModel, photo: [UIImage], onCompletion: @escaping (Result<Int,DomainError>)->()){
        //
        var count = 0
        print("POINTS \(points)")
        let eventRef = self.storage.child("events_v1").child("\(groupId)")
        
        var eventURLS : [String] = []
        let max = photo.count
        
        for (index,photo) in photo.enumerated() {
            let data = photo.jpegData(compressionQuality: 0.5)!
            let picRef = eventRef.child("event_pic_\(event.eventMonth)\(event.id)_\(index).jpg")
            picRef.putData(data, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    onCompletion(.failure(.downloadError))
                    return
                }
                picRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        print("an error occured after uploading and then getting the URL")
                        onCompletion(.failure(.downloadError))
                        return
                    }

                    eventURLS.append(downloadURL.absoluteString)
                    count += 1
                    if count == max {
                        print("EVENT URLS \(eventURLS)")

                        self.db.collection("group_v2").document(groupId).collection("group_events_v1").document("\(event.eventMonth)\(event.id)").updateData([
                            "photoURL" : eventURLS
                        ])
                        let randomId = UUID().uuidString
                        self.db.collection("group_v2").document(groupId).getDocument { doc, error in
                            guard let doc = doc , error == nil else {
                                onCompletion(.failure(.downloadError))
                                return
                            }
                            let groupName = doc.get("teamName") as! String
                            self.db.collection("completed_events").document(randomId).setData([
                                "photoURLS" : eventURLS,
                                "groupId" : groupId,
                                "eventName" : event.eventName,
                                "eventType" : event.eventType,
                                "eventMonth" : event.eventMonth,
                                "teamName" : groupName,
                                "timeStamp" : Timestamp(),
                                "likes": 0,
                                "commentNum" : 0,
                                "id": event.id,
                                "isGlobal" : isGlobal
                                
                                
                            ])
                            print("points about to submit \(points)")
                            onCompletion(.success(points))
                            return
                        }
                    }
                }

            }
        }
        
     
       
    }


                    
             
                    
                     

    
    private func submitPhotoURLToDB(url: String, onCompletion:@escaping(Result<Bool,DomainError>)->()){
        
    }
    func fetchComments(id:String, onCompletion:@escaping (Result<[CommentModel],DomainError>)->()){
        
        db.collection("completed_events").document(id).collection("comments").order(by:"timeStamp", descending: false).getDocuments { query, error in
            guard let query = query, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            var comments:[CommentModel] = []
            if query.count == 0  {
                onCompletion(.success([]))
                return
            }
            var count = 0
            let maxCount = query.count
            for doc in query.documents {
                let comment = doc.get("comment") as! String
                let name = doc.get("name") as! String
                let role = doc.get("role") as! String
                let groupId = doc.get("teamId") as! String
                let teamName = doc.get("teamName") as! String 

                comments.append(CommentModel(name: name,role: role ,teamId:groupId,comment: comment, teamName: teamName))
                count += 1
                if (count == maxCount ){
                    onCompletion(.success(comments))
                    return
                }
            }
            
        }
        
        
    }
    func comment(comment: String, id:String, onCompletion:@escaping(Result<CommentModel,DomainError>)->()){
        let randomId = UUID().uuidString
        
        profileViewModel.fetchMember { result in
            switch result {
            case .success(let user):
                let name = user.name
                let role = user.role
                let groupId = user.groupId
                
                if groupId != ""{
                    self.profileViewModel.fetchTeam(id: groupId) { result in
                        switch result{
                        case .success(let team):
                            let teamName = team.teamName
                            self.db.collection("completed_events").document(id).collection("comments").document(randomId).setData([
                                "timeStamp" : Timestamp(),
                                "comment": comment ,
                                "userId" : self.userId!,
                                "name": name,
                                "docId" : randomId,
                                "teamId" : groupId,
                                "role" : role,
                                "teamName": teamName
                                
                                
                            
                            ])
                            self.db.collection("completed_events").document(id).getDocument { doc, error in
                                guard let doc = doc , error == nil else {
                                    onCompletion(.failure(.uploadError))
                                    return
                                } 
                                let currentCommentCount = doc.get("commentNum") as! Int
                                 self.db.collection("completed_events").document(id).updateData([
                                    "commentNum" : currentCommentCount+1
                                ])
                                
                                onCompletion(.success(CommentModel(name: name, role: role, teamId:groupId,comment:comment, teamName: teamName)))
                                return
                            }
                        case .failure(_):
                            self.db.collection("completed_events").document(id).collection("comments").document(randomId).setData([
                                "timeStamp" : Timestamp(),
                                "comment": comment ,
                                "userId" : self.userId!,
                                "name": name,
                                "docId" : randomId,
                                "teamId" : groupId,
                                "role" : role,
                                "teamName": "Team"
                                
                                
                            
                            ])
                            self.db.collection("completed_events").document(id).getDocument { doc, error in
                                guard let doc = doc , error == nil else {
                                    onCompletion(.failure(.uploadError))
                                    return
                                }
                                let currentCommentCount = doc.get("commentNum") as! Int
                                 self.db.collection("completed_events").document(id).updateData([
                                    "commentNum" : currentCommentCount+1
                                ])
                                
                                onCompletion(.success(CommentModel(name: name, role: role, teamId:groupId,comment:comment, teamName: "Team")))
                                return
                            }
                        }
                    }
                }else{
                    self.db.collection("completed_events").document(id).collection("comments").document(randomId).setData([
                        "timeStamp" : Timestamp(),
                        "comment": comment ,
                        "userId" : self.userId!,
                        "name": name,
                        "docId" : randomId,
                        "teamId" : groupId,
                        "role" : role,
                        "teamName": ""
                        
                        
                    
                    ])
                    self.db.collection("completed_events").document(id).getDocument { doc, error in
                        guard let doc = doc , error == nil else {
                            onCompletion(.failure(.uploadError))
                            return
                        }
                        let currentCommentCount = doc.get("commentNum") as! Int
                         self.db.collection("completed_events").document(id).updateData([
                            "commentNum" : currentCommentCount+1
                        ])
                        
                        onCompletion(.success(CommentModel(name: name, role: role, teamId:groupId,comment:comment, teamName: "")))
                        return
                    }
                }


            case .failure(let error):
                print("Error fetching name for comments \(error)")
                onCompletion(.failure(error))
                return
            }
        }

        
    }
    func clearDocQuery(){
        print("cleared doc query")
        self.lastDocQuery = nil
    }
    func fetchCompletedEventsCache()->[FetchedEvent] {
        return self.completedEvents
    }
    func ClearQueryCache() {
        self.lastDocQuery = nil 
    }
    func ClearCache() {
        self.completedEvents = []
    }
    func fetchAllianceURLS(alliances:[String],events: [FetchedEvent],season: String, skip:Bool, onCompletion:@escaping(Result<[FetchedEvent],DomainError>)->()){
        
//         self.isFetchingMoreDocs = true
        print("ALLIANCS \(alliances)")
        var limit = 2
        var docQuery: Query!
        if events.isEmpty && !skip{
            docQuery = db.collection("completed_events").order(by: "timeStamp", descending: true).limit(to: limit)
        }else if let lastDocQuery = self.lastDocQuery {
            self.isFetchingMoreDocs = true
            docQuery = db.collection("completed_events").order(by: "timeStamp", descending: true).limit(to: limit).start(afterDocument: lastDocQuery)
          
        }else{
            
            onCompletion(.failure(.downloadError))
        }

        docQuery.getDocuments(completion: { doc, error in
            guard let documentSnapshot = doc, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            var fetchedEvents : [FetchedEvent] = []
            var count = 0
            let maxCount = documentSnapshot.count
          if maxCount == 0 {
              print("theres no more documents")
              onCompletion(.success([]))
              return
          }
            var skip = 0
            for document in documentSnapshot.documents {
                
                let groupId = document.get("groupId") as! String
                print("Times going thourhg for loop")
                if !alliances.contains(groupId) {
                    print("Group id \(groupId)")
                    self.lastDocQuery = documentSnapshot.documents.last
                    print("skipping in alliances")
                    skip += 1
                    
//                    if skip + count >= limit {
//                        if count > 0 {
//                            onCompletion(.success(fetchedEvents))
//                            return
//                        }else{
//
//                            self.fetchAllianceURLS(alliances: alliances, events: events, season: season, skip: true, onCompletion: onCompletion)
//                            return
//                        }
                    if skip >= limit {
                 
                            print("limit")
                            self.fetchAllianceURLS(alliances: alliances, events: events, season: season, skip: true, onCompletion: onCompletion)
                            return
                    }
                    continue
                }
                
                
//                let eventIsGlobal = document.get("isGlobal") as! Bool
                let photoURL = document.get("photoURLS") as! [String]
                let eventName = document.get("eventName") as! String
                let eventType = document.get("eventType") as! String
                let eventMonth = document.get("eventMonth") as! String
                let teamName = document.get("teamName") as! String
                let id = document.get("id") as! String
                let likes = document.get("likes") as! Int
                let commentsNum = document.get("commentNum") as! Int
                let timeStamp = document.get("timeStamp") as! Timestamp
                
                let formatter = DateFormatter()
                let newValue = timeStamp.dateValue()
                formatter.dateStyle = .short
                formatter.timeStyle = .none
                let time = formatter.string(from: newValue)

                print("in the document snapshot")
                self.db.collection("completed_events").document(document.documentID).collection("likes").document(self.profileViewModel.fetchUserId()).getDocument { doc, error in
                       if let doc = doc, doc.exists {
                           
                           let event : FetchedEvent = FetchedEvent(photoURLS: photoURL, groupId: groupId , eventName: eventName, eventType: eventType, eventMonth: eventMonth, teamName: teamName, id: id, documentId: document.documentID, likes: likes, comments: commentsNum,  didILike: true, timeStamp: time)
                           fetchedEvents.append(event)
                           count += 1
                           self.lastDocQuery = documentSnapshot.documents.last

                           if (skip + count == maxCount){
                               self.completedEvents.append(contentsOf: fetchedEvents)
                               onCompletion(.success(fetchedEvents))
                               return
                           }
                        }
                        else{
                            
                            let event : FetchedEvent = FetchedEvent(photoURLS: photoURL, groupId: groupId , eventName: eventName, eventType: eventType, eventMonth: eventMonth, teamName: teamName, id: id, documentId: document.documentID, likes: likes,  comments: commentsNum, didILike: false, timeStamp: time  )
                            fetchedEvents.append(event)
                            count += 1
                            self.lastDocQuery = documentSnapshot.documents.last
                                             self.isFetchingMoreDocs = false
                            if (skip + count == maxCount){
                                self.completedEvents.append(contentsOf: fetchedEvents)

                                onCompletion(.success(fetchedEvents))
                                return
                            }
                        }
                    
                }
                    
                
            }

        })
 
    }
    func fetchGlobalURLS(alliances:[String],isGlobal:Bool,events: [FetchedEvent],season: String, skip:Bool, onCompletion:@escaping(Result<[FetchedEvent],DomainError>)->()){
        
//         self.isFetchingMoreDocs = true
        
        let limit = 2
        var docQuery: Query!
        if events.isEmpty && !skip{
            docQuery = db.collection("completed_events").order(by: "timeStamp", descending: true).limit(to: limit)
        }else if let lastDocQuery = self.lastDocQuery {
            self.isFetchingMoreDocs = true
            docQuery = db.collection("completed_events").order(by: "timeStamp", descending: true).limit(to: limit).start(afterDocument: lastDocQuery)
          
        }else{
            
            onCompletion(.failure(.downloadError))
        }

        docQuery.getDocuments(completion: { doc, error in
            guard let documentSnapshot = doc, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            var fetchedEvents : [FetchedEvent] = []
            var count = 0
            let maxCount = documentSnapshot.count
          if maxCount == 0 {
              print("theres no more documents")
              onCompletion(.success([]))
              return
          }
            
            var skip = 0
            for document in documentSnapshot.documents {
                
                let eventIsGlobal = document.get("isGlobal") as! Bool
//                print("event is global \(eventIsGlobal)")

                if !eventIsGlobal {

                    self.lastDocQuery = documentSnapshot.documents.last
                    skip += 1
//                    print("inside Count \(count) and skip \(skip)")

                    if skip >= limit {
//                        print("Count \(count) and skip \(skip)")

//                        if count > 0 {
//                            print("completing early")
//                            onCompletion(.success(fetchedEvents))
//                            return
//                        }else{
//                            print("retfeching for skips")
//                            self.fetchGlobalURLS(alliances: alliances, isGlobal: isGlobal, events: events, season: season, skip: true, onCompletion: onCompletion)
//                            return
//                        }
                
                            self.fetchGlobalURLS(alliances: alliances, isGlobal: isGlobal, events: events, season: season, skip: true, onCompletion: onCompletion)
                            return
                  
                    }
                    continue
                }
                
                let groupId = document.get("groupId") as! String
                let photoURL = document.get("photoURLS") as! [String]
                let eventName = document.get("eventName") as! String
                let eventType = document.get("eventType") as! String
                let eventMonth = document.get("eventMonth") as! String
                let teamName = document.get("teamName") as! String
                let id = document.get("id") as! String
                
                let likes = document.get("likes") as! Int
                let commentsNum = document.get("commentNum") as! Int
                let timeStamp = document.get("timeStamp") as! Timestamp
                
                let formatter = DateFormatter()
                let newValue = timeStamp.dateValue()
                formatter.dateStyle = .short
                formatter.timeStyle = .none
                let time = formatter.string(from: newValue)

//                print("in the document snapshot")
                self.db.collection("completed_events").document(document.documentID).collection("likes").document(self.profileViewModel.fetchUserId()).getDocument { doc, error in
                       if let doc = doc, doc.exists {
                           
                           let event : FetchedEvent = FetchedEvent(photoURLS: photoURL, groupId: groupId , eventName: eventName, eventType: eventType, eventMonth: eventMonth, teamName: teamName, id: id, documentId: document.documentID, likes: likes, comments: commentsNum,  didILike: true, timeStamp: time)
                           fetchedEvents.append(event)
//                           print("Counting")
                           count += 1
                           self.lastDocQuery = documentSnapshot.documents.last

                           if (count + skip == maxCount){
                               self.completedEvents.append(contentsOf: fetchedEvents)
                               onCompletion(.success(fetchedEvents))
                               return
                           }
                        }
                        else{
                            
                            let event : FetchedEvent = FetchedEvent(photoURLS: photoURL, groupId: groupId , eventName: eventName, eventType: eventType, eventMonth: eventMonth, teamName: teamName, id: id, documentId: document.documentID, likes: likes,  comments: commentsNum, didILike: false, timeStamp: time  )
                            fetchedEvents.append(event)
//                            print("Counting")

                            count += 1
                            self.lastDocQuery = documentSnapshot.documents.last
                                             self.isFetchingMoreDocs = false
                            if (count + skip == maxCount){
                                self.completedEvents.append(contentsOf: fetchedEvents)

                                onCompletion(.success(fetchedEvents))
                                return
                            }
                        }
                    
                }
                    
                
            }

        })
 
    }
    func fetchPhotoURLS(alliances:[String],isGlobal:Bool,events: [FetchedEvent],season: String, onCompletion:@escaping(Result<[FetchedEvent],DomainError>)->()){
        
        if isGlobal{
            fetchGlobalURLS(alliances: alliances, isGlobal: isGlobal, events: events, season: season, skip: false, onCompletion: onCompletion)
        }else{
            fetchAllianceURLS(alliances: alliances, events: events, season: season, skip:false,onCompletion: onCompletion)
        }


    }
    
    
    //submit event photo, and event in firebase
    // check to see if event has already been completed
    // if it has do not submit, if it hasnt submit
    // update points
     func checkLiveStatus(onCompletion:@escaping (Result<LiveEventModel,DomainError>)->()){
        
//       let liveEventRef = db.collection("server_v1").whereField("isActive",isEqualTo: true)
        let liveEventRef = db.collection("server_v1").document("0")
            
            liveEventRef.getDocument { document, error in
            guard let document = document, error == nil else{
                onCompletion(.failure(.downloadError))
                return
            }
                let isActive = document.get("isActive") as! Bool
//                let startTime = Date(timeIntervalSinceReferenceDate: document.get("gameStart") as! Double)
//                let beginningTime = Date(timeIntervalSinceReferenceDate: document.get("beginning") as! Double)
                let startStamp : Timestamp = document.get("gameStart") as! Timestamp
                let startTime = startStamp.dateValue()
                let beginningStamp  : Timestamp = document.get("beginning") as! Timestamp
                let beginningTime = beginningStamp.dateValue()

                let seconds = document.get("totalSeconds") as! Int
                let prize = document.get("prize") as! String
                let season = document.get("season") as! String
                let isSelection = document.get("isSelection") as! Bool
                if !isActive{
                    let liveEvent : LiveEventModel = LiveEventModel(startTime: startTime, isActive: false, videoURL: "", seconds: seconds, beginingTime: beginningTime, prize: prize, season: season, isSelection: isSelection)
                    print(liveEvent)
                    onCompletion(.success(liveEvent))
                    return
                }
             
               
                let videoURL = document.get("videoStream") as! String
                
                let liveEvent : LiveEventModel = LiveEventModel(startTime: startTime, isActive: isActive, videoURL: videoURL, seconds: seconds, beginingTime: beginningTime, prize: prize, season: season, isSelection:isSelection)
                onCompletion(.success(liveEvent))
                return
     
            
            
        }
  
    }

    
    func suggestEvent(event: EventModel, onCompletion : @escaping(Result<Void,DomainError>)->()){
        
        db.collection("suggested_events_v1").document(UUID().uuidString).setData([
            "Name" : event.eventName
            ,
            "Description": event.eventDescription,
            "Rules":event.eventRules,
            "Location":event.eventLocation,
            "Time":event.id,
            "Cost":event.eventMonth,
            "Type":event.eventType,
            "suggesterId" : userId!,
            "approved": false
        
        ])
        onCompletion(.success(()))
        return 
        
        
        
        
    }
    func submitPoints(groupId: String, points: Int, onCompletion: @escaping(Result<Bool,DomainError>)->()){
        
        let pointsRef = db.collection("raffle_users_v2").document(groupId)
        let groupRef = db.collection("group_v1").document(groupId)
        let seasonRef = db.collection("server_v1").document("0")
        
        groupRef.getDocument { document, error in
            guard let document = document, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            let currentPoints = document.get("points") as! Int
            
            if currentPoints < points {
                onCompletion(.success(false))
                return
            }
            pointsRef.getDocument { document, error in
                if error != nil {
                    onCompletion(.failure(.downloadError))
                    return
                }
                if let document = document, document.exists {
                    
                    let currentPoints = document.get("raffles") as! Int
                    let newPoints = currentPoints + points/100
                    pointsRef.updateData([
                        "raffles" : newPoints
                    ])
                }
                else{
                    seasonRef.getDocument { doc, error in
                        guard let doc = doc , error == nil else{
                            onCompletion(.failure(.downloadError))
                            return
                        }
                        let season = doc.get("season") as! Int
                        pointsRef.setData([
                            "raffles": points/100,
                            "groupId" : groupId,
                            "season" : season
                        
                        ])
                    }
       
                }
                groupRef.updateData([
                    "points" : currentPoints - points
                ])
                onCompletion(.success(true))
                return
            }
            
        }
        

        
        
        
        
        
        
    }

    func fetchPoints(groupId: String, onCompletion:@escaping(Result<PointsModel,DomainError>)->()){
        
        let pointRef = db.collection("raffle_users_v2").document(groupId)
        let groupRef = db.collection("group_v1").document(groupId)
        let seasonRef = db.collection("server_v1").document("0")
        
        pointRef.getDocument { doc, error in
            if let doc = doc , doc.exists{
                let currentRaffles = doc.get("raffles") as! Int
                
                //                let currentRaffles = currentPoints % 100
                
                groupRef.getDocument { document, error in
                    guard let document = document, error == nil else {
                        onCompletion(.failure(.downloadError))
                        return
                    }
                    seasonRef.getDocument { docs, error in
                        guard let docs = docs , error == nil else {
                            onCompletion(.failure(.downloadError))
                            return
                        }
                        let currentSeason = docs.get("season") as! Int
                        let currentGroupPoints = document.get("points") as! Int
                        onCompletion(.success(PointsModel(currentPoints: currentGroupPoints, currentRaffles: currentRaffles, season: currentSeason)))
                        return
                    }
         
                }
                
            }
            else{
                groupRef.getDocument { document, error in
                    guard let document = document, error == nil else {
                        onCompletion(.failure(.downloadError))
                        return
                    }
                    let currentGroupPoints = document.get("points") as! Int
                    seasonRef.getDocument { docs, error in
                        guard let docs = docs , error == nil else {
                            onCompletion(.failure(.downloadError))
                            return
                        }
                        let currentSeason = docs.get("season") as! Int

                        onCompletion(.success(PointsModel(currentPoints: currentGroupPoints, currentRaffles: 0, season: currentSeason)))
                        return
                    }
            
                }
            }
        }
        
    }
    
    func fetchEventPictures(season: Int, onCompletion: @escaping(Result<[UIImage], DomainError>)->()){
        let eventRef = storage.child("events_v1").child("\(season)")
       eventRef.listAll(completion: { (result, error) in
           if error != nil{
               print("error downloading pictures")
               onCompletion(.failure(.downloadError))
               return
           }
           var profilePictures: [UIImage] = []
           var count = 0
           var hasFailed = false
//            for picRef in result.items{


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
    func likeEvent(id: String, onCompletion:@escaping () -> ()  ){
        
        let eventRef = db.collection("completed_events").document(id)
        
        eventRef.collection("likes").document(profileViewModel.fetchUserId()).getDocument {  doc, error in
            if let doc = doc, doc.exists {
                return
            }
            else{
                eventRef.getDocument { document, error in
                    guard let document = document, error == nil else {
                        return
                    }
                    let currentLikes = document.get("likes") as! Int
                    let groupId = document.get("groupId") as! String
                    let event = document.get("eventName") as! String
                    eventRef.collection("likes").document(self.userId!).setData([
                        "like": true,
                        "groupId": groupId,
                        "event" : event
                    ])
                    eventRef.updateData([
                        "likes": currentLikes + 1
                    ])
                    return


                }
            }
        }
        
   
        
    }
    func dislikeEvent(id:String, onCompletion:@escaping () -> ()){
        let eventRef = db.collection("completed_events").document(id)
        
        eventRef.collection("likes").document(userId!).getDocument {  doc, error in
            if let doc = doc, doc.exists {
                eventRef.getDocument { document, error in
                    guard let document = document, error == nil else {
                        return
                    }
                    let currentLikes = document.get("likes") as! Int

                    eventRef.collection("likes").document(self.userId!).delete()
                    eventRef.updateData([
                        "likes" : currentLikes - 1
                    ])
                }


            }
            else{
                
                return
            }
        }
        
    }
    
    func saveEvent(id:String , onCompletion: @escaping (Result<Bool,DomainError>)->()){
        
        profileViewModel.fetchMember { result in
            switch result{
            case .success(let user):
                if user.groupId == "" {
                    onCompletion(.failure(.localfetchingError))
                    return
                }

                
                          self.profileViewModel.fetchTeam(id: user.groupId) { result in
                              switch result{
                              case .success(let team):
                                  var currentSuggestions = team.suggestedEvents
                                  
                                  var count = 0
                                  var isThere = false
                                  for suggestion in currentSuggestions {
                                      if suggestion == id {
                                          isThere = true
                                          break
                                      }
                                      count += 1
                                  }
                                  if isThere{
                                      currentSuggestions.remove(at: count)
                                  }
                                  else{
                                      currentSuggestions.append(id)
                                  }
                                  self.db.collection("group_v2").document(user.groupId).updateData([
                                      "suggestedEvents" : currentSuggestions
                                  ])
                                  
                                  if isThere{
                                      onCompletion(.success(false))
                                  }else{
                                      onCompletion(.success(true))

                                  }
                                  return
                              case .failure(let error):
                                  print("error saving event in personal profile \(error)")
                                  onCompletion(.failure(.uploadError))
                                  return
                              }
                          }
                  
              case .failure(let error):
                  print("error saving event \(error)")
                  onCompletion(.failure(.localfetchingError))
                  return
                      }
                
             
                      
             

                  }

              }
        
 
        
    
    func fetchSavedEvents(teamId: String, chosen:String, suggestedEvents:[String],onCompletion: @escaping (Result<[EventModelWithLikes],DomainError>)->()){
        let savedRef = db.collection("events_v1")
     
            savedRef.getDocuments { documents, error in
                guard let documents = documents, error == nil else {
                    onCompletion(.failure(.downloadError))
                    return
                }
                var count = 0
                let maxCount = documents.documents.count
                var events : [EventModelWithLikes] = []
                for document in documents.documents {
                    
                    
                    var dict = document.data()
                    let decoder = JSONDecoder()
                    for (key, value) in dict {

                    if let value = value as? Timestamp {

                        let formatter = DateFormatter()
                        let newValue = value.dateValue()
                        formatter.dateStyle = .short
                        formatter.timeStyle = .none
                        
                        dict[key] = formatter.string(from: newValue)
                        
                        print(formatter.string(from:newValue))
                       }
                     }
                    if let data = try? JSONSerialization.data(withJSONObject: dict, options:[]){
                        
                        do {
                            
                            let event : EventModel = try! decoder.decode(EventModel.self, from: data)
                            var suggested = false
                            for suggestions in suggestedEvents {
                                if suggestions == event.id {
                                    suggested = true
                                    print("in suggested list")
                                }
                                
                            }
                            if suggested{
                                self.db.collection("group_v2").document(teamId).collection("suggested_events_v1").document(event.id).getDocument { doc, error in
                                    guard let doc = doc , error == nil else{
                                        onCompletion(.failure(.downloadError))
                                        return
                                    }
//                                    print("getting likes")
                                    let likes = doc.get("likes") as! Int
                                    let likers = doc.get("likers") as! [String]
                                    
//                                    print("likes total \(likes)")
                                    
                                    var didILike : Bool {
                                        for liker in likers {
                                            if liker == self.userId!{
//                                                print("i liked this already")
                                                return true
                                            }
                                        }
                                        return false
                                    }
//                                    print("second likes total \(likes)")

                                    let eventWithLikes : EventModelWithLikes = EventModelWithLikes(event: event, likes: likes, chosen: didILike)
                                    events.append(eventWithLikes)
                                    count += 1
                                    print("count \(count)")
                                    if count == maxCount {
                                        onCompletion(.success(events))
                                        return
                                        
                                    }

                                }

                            }else{
                                count += 1

                            }
                            print("count \(count)")
                            if count == maxCount {
                                onCompletion(.success(events))
                                return
                                
                            }
                            
                        }
                        
                    }
                }
                
            }
        
    }
    func unsaveSuggestedEvent(groupId:String, id:String, onCompletion:@escaping(Result<Void,DomainError>)->()){
        let suggestRef = db.collection("group_v2").document(groupId)
        
        suggestRef.getDocument { document, error in
            guard let document = document, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            var currentSuggestions = document.get("suggestedEvents") as! [String]
            var index = 0
            for currentIndex in currentSuggestions.indices {
                if currentSuggestions[currentIndex] == id {
                    index = currentIndex
                }
            }
            currentSuggestions.remove(at: index)
            suggestRef.updateData([
                "suggestedEvents" : currentSuggestions
            ])
            suggestRef.collection("suggested_events_v1").document(id).delete()
            onCompletion(.success(()))
            return
            
        }

    }
    func likeSuggestedEvent(groupId:String, id:String, onCompletion:@escaping (Result<Void,DomainError>)->()){
        
        let suggestRef = db.collection("group_v2").document(groupId).collection("suggested_events_v1")
        
        suggestRef.document(id).getDocument { doc, error in
            guard let doc = doc , error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            var likers = doc.get("likers") as! [String]
            var totalLikes = doc.get("likes") as! Int
            var didILike : Bool = false
            var index : Int = 0
            
            for likeIndex in likers.indices {
                if self.userId! == likers[likeIndex] {
                    didILike = true
                    index = likeIndex
                }
            }
            
            if didILike {
                likers.remove(at: index)
                totalLikes -= 1
                
            }else{
                likers.append(self.userId!)
                totalLikes += 1

            }
            suggestRef.document(id).updateData([
                "likers" : likers ,
                "likes" : totalLikes
            ])
            onCompletion(.success(()))
            return
            
        }
        
        
        
    }
    func setEvent(teamName:String,groupId:String, id:String, date: Date, openEvent:Bool, note:String,onCompletion:@escaping ()->() ){
        
        let suggestRef = db.collection("group_v2").document(groupId)
        
        suggestRef.updateData([
            "chosenEvent" : id,
            "setTimeForChosenEvent" : date
        ])
        
        if openEvent{
            suggestRef.collection("chosen_event").document(id).setData([
                "chosenEvent" : id,
                "setTimeForChosenEvent" : date,
                "openEvent" : openEvent,
                "teamName" : teamName,
                "note":note
            ])
        }

        
       onCompletion()
        return

        
        
    }
    func unSetEvent(groupId:String, id:String, onCompletion:@escaping () ->()){
        
        let suggestRef = db.collection("group_v2").document(groupId)

        suggestRef.updateData([
            "chosenEvent" : ""

        ])
        
        suggestRef.collection("chosen_event").document(id).getDocument { doc, error
            in
     
            if let doc = doc, doc.exists{
                suggestRef.collection("chosen_event").document(id).delete()

            }
            onCompletion()
            return

        }
        
        

        
    }
    func fetchCompletedEventsForSubmissions(groupId: String, onCompletion: @escaping (Result<[CompletedEvent],DomainError>)->()){
        
        db.collection("group_v2").document(groupId).collection("group_events_v1").whereField("submittedForPoints", isEqualTo: false).getDocuments { snapshot, error in
            guard let documentSnapshot = snapshot, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            if documentSnapshot.isEmpty{
                onCompletion(.success([]))
                return
            }
                var count = 0
                let maxCount = documentSnapshot.documents.count
                let decoder = JSONDecoder()

                var completedEvents : [CompletedEvent] = []
                
                for document in documentSnapshot.documents {
                    
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
                        
                        //                        do {
                        
                        let event : CompletedEvent = try! decoder.decode(CompletedEvent.self, from: data)
                        
                        completedEvents.append(event)
                        
                        count += 1
                        
                        if count == maxCount {
                            onCompletion(.success(completedEvents))
                        }
                        
                    }
                }
                
                
        }
    
    
    }
    func submitPoints( groupId:String, points: Int, submittedEvents : [CompletedEvent],onCompletion: @escaping (Result<Void,DomainError>)->()){
        
        let lovols : Int = (points/100)
        print(points)

        let completeEventRef = db.collection("group_v2").document(groupId)
        
        for submittedEvent in submittedEvents {
            completeEventRef.collection("group_events_v1").document("\(submittedEvent.eventMonth)\(submittedEvent.id)").updateData([
                "submittedForPoints" : true
            ])
        }
        completeEventRef.getDocument { document, error in
            guard let document = document, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            var currentLovol = document.get("teamLovols") as! Int
            currentLovol += lovols
            completeEventRef.updateData([
                "teamLovols" : currentLovol,
                "lifeTimeLovols" : currentLovol
            ])
            onCompletion(.success(()))
            return
        }
    
        
        
    }
    func fetchCompletedEvents(groupId: String, onCompletion:@escaping (Result<[FetchedEvent],DomainError>) ->()){
        
        let fetchedEventRef = db.collection("completed_events").whereField("groupId", isEqualTo: groupId)
        
        fetchedEventRef.getDocuments { snapshot, error in
            guard let documentSnapshot = snapshot, error == nil else {
                print("Error fetching c ompleted events")
                onCompletion(.failure(.downloadError))
                return
            }
            var count = 0
            let maxCount = documentSnapshot.documents.count
//            let decoder = JSONDecoder()
            
            if maxCount == 0 {
                onCompletion(.success([]))
                print("empty")
                return
            }

            var completedEvents : [FetchedEvent] = []
            
            for document in documentSnapshot.documents {
                
//                var dict = document.data()
//                for (key, value) in dict {

//                if let value = value as? Timestamp {
//
//                    let formatter = DateFormatter()
//                    let newValue = value.dateValue()
//                    formatter.dateStyle = .short
//                    formatter.timeStyle = .none
//                    dict[key] = formatter.string(from: newValue)
//                   }
//                 }
                let photoURL = document.get("photoURLS") as! [String]
                let eventName = document.get("eventName") as! String
                let eventType = document.get("eventType") as! String
                let eventMonth = document.get("eventMonth") as! String
                let groupId = document.get("groupId") as! String
                let teamName = document.get("teamName") as! String
                let id = document.get("id") as! String
                let documentId = document.documentID
                let likes = document.get("likes") as! Int
                let commentsNum = document.get("commentNum") as! Int
                let timeStamp = document.get("timeStamp") as! Timestamp
                let formatter = DateFormatter()
                let newValue = timeStamp.dateValue()
                formatter.dateStyle = .short
                formatter.timeStyle = .none
                let time = formatter.string(from: newValue)
                
//                if let data = try? JSONSerialization.data(withJSONObject: dict, options:[]){
                    
                    //                        do {
                    
                let event : FetchedEvent = FetchedEvent(photoURLS: photoURL, groupId: groupId, eventName: eventName, eventType: eventType, eventMonth: eventMonth, teamName: teamName, id: id, documentId: documentId, likes: likes, comments: commentsNum, didILike: false, timeStamp: time)
                    
                    completedEvents.append(event)
                    
                    count += 1
                    print("Count \(count)")
                    if count == maxCount {
                        onCompletion(.success(completedEvents))
                        return
                    }
                    
//                }
            }
            
        }
        
        
    }
    
    func fetchHeadLiners(onCompletion:@escaping(Result<[HeadLiners], DomainError>)->()){
        
        let headRef = db.collection("weekly_events")
        
        headRef.getDocuments { query, error in
            guard let documents = query, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            var count = 0
            let maxCount = documents.documents.count
            
            var headLiners : [HeadLiners] = []
            
            for document in documents.documents {
                let header = document.get("header") as! String
                let tags = document.get("tags") as! [String]
                
                headLiners.append(HeadLiners(header: header, tags: tags, events: []))
                count += 1
                
                if count == maxCount {
                    print("sucesss headliners \(headLiners)")
                    onCompletion(.success(headLiners))
                    return
                }
            }
        }
    }
    func fetchEventsCompleted(season:String,onCompletion:@escaping(Result<[CompletedEvent],DomainError>)->()) {
        profileViewModel.fetchMember { result in
            switch result{
            case .success(let user):
                let groupId = user.groupId
                if groupId == "" {
                    print("not in group when fetching events")
                    onCompletion(.success([]))
                    return
                }
                let groupEventsRef = self.db.collection("group_v2").document(groupId)
                groupEventsRef.collection("group_events_v1").whereField("eventMonth", isEqualTo: season).getDocuments(completion: { documentSnapShot, error in
                    guard error == nil else {
                        print("error", error ?? "")
                        onCompletion(.failure(.downloadError))
                        return
                    }
                    print("in group")
                    var completedEvents : [CompletedEvent] = []
                    var count = 0
                    let maxCount = documentSnapShot?.documents.count
                    if (maxCount == 0 ){
                        onCompletion(.success([]))
                    }
                    for document in documentSnapShot!.documents{
                        let completedId : String = document.get("id") as! String
                        let completedURL : [String] = document.get("photoURL") as! [String]
                        let completedType : String = document.get("eventType") as! String

                        let completedMonth : String = document.get("eventMonth") as! String
                        let completedName : String = document.get("eventName") as! String
                        let completedPoints : Int = document.get("eventPoints") as! Int
                        let completedSubmittedPoints : Bool = document.get("submittedForPoints") as! Bool

                        completedEvents.append(CompletedEvent(photoURL: completedURL, eventName: completedName, eventMonth: completedMonth, eventPoints: completedPoints, id: completedId, submittedForPoints: completedSubmittedPoints, eventType:completedType))
                        count += 1
                        if maxCount == count {
                            onCompletion(.success(completedEvents))
                            return
                        }
                    }
                    
                    
                })
            case .failure(let error):
                print("error \(error)")
            }
        }

 
        
        
    }
    func fetchSavedEvents(alliances:[String], groupId:String, onCompletion:@escaping(Result<[SavedEvent],DomainError>)->()) {
       
     
                
                
                let teamRef = self.db.collection("group_v2")
                
                teamRef.document(groupId).collection("chosen_event").getDocuments { query, error in
                    guard let documents = query, error == nil else {
                        onCompletion(.failure(.downloadError))
                        return
                    }
                    let count = documents.documents.count
                    
                    if count == 0 {
                        self.fetchAllianceSavedEvents(currentSaved: [], alliances: alliances, onCompletion: onCompletion)
                        return
                    }else{
                        
                        let document = documents.documents[0]
                        let eventId = document.get("eventId") as! String
                        let eventNote = document.get("note") as! String
                        let eventDate = document.get("setTimeForChosenEvent") as! Timestamp
                        let teamName = document.get("teamName") as! String

                        
//                        let formatter = DateFormatter()
                        let newValue = eventDate.dateValue()
//                        formatter.dateStyle = .short
//                        formatter.timeStyle = .none
//                        let newDate = formatter(from: newValue)
                        let savedEvent : [SavedEvent] = [SavedEvent(event: EventModel(), teamName: teamName, note: eventNote, date: newValue, eventId: eventId)]
                        self.fetchAllianceSavedEvents(currentSaved: savedEvent, alliances: alliances, onCompletion: onCompletion)

                    }
                }
                
       
        
    }
    func fetchAllianceSavedEvents( currentSaved:[SavedEvent],alliances:[String],onCompletion:@escaping(Result<[SavedEvent],DomainError>)->()){
        if alliances.isEmpty {
            onCompletion(.success(currentSaved))
            return
        }
        var events : [SavedEvent] = currentSaved
        var allianceMax = alliances.count
        
        var count = 0
        for alliance in alliances {
            let allianceRef = db.collection("group_v2").document(alliance).collection("chosen_event")
            
            allianceRef.getDocuments { query, error in
                guard let documents = query, error == nil else {
                    return
                }
                
                let docCount = documents.documents.count
                
                if docCount != 0 {
                    let document = documents.documents[0]
                    let eventId = document.get("eventId") as! String
                    let eventNote = document.get("note") as! String
                    let eventDate = document.get("setTimeForChosenEvent") as! Date
                    let teamName = document.get("teamName") as! String

                    let savedEvent : SavedEvent = SavedEvent(event: EventModel(), teamName: teamName, note: eventNote, date: eventDate, eventId: eventId)
                    events.append(savedEvent)
                    
                    count += 1
                    
                    if allianceMax == count {
                        onCompletion(.success(events))
                        return
                    }
                    
                }else{
                    count += 1
                    
                    if allianceMax == count {
                        onCompletion(.success(events))
                        return
                    }
                }
            }
            

        }
        
    }
    func convertSavedEvents(locationSet:Bool, long:Double,lat:Double,eventIds:[SavedEvent],onCompletion:@escaping(Result<[SavedEvent],DomainError>)->()){
        var editedEvents : [SavedEvent] = []
        
        var count = 0
        let maxCount = eventIds.count
        
        if eventIds.isEmpty{
            onCompletion(.success([]))
            return
        }
        for eventId in eventIds {
            db.collection("events_v1").document(eventId.eventId).getDocument { doc, error in
                guard let document = doc , error == nil else {
                    return
                }
                let eventLong = document.get("long") as! Double
                let eventLat = document.get("lat") as! Double
                
                print("long and lats being commpared are \(long) and \(eventLong) ,, \(lat) and \(eventLat)")
                
                let distance = self.distance(lat1: eventLat, lon1: eventLong, lat2: lat, lon2: long)
                
                print("distance \(distance)")
                
                
                
                let id = document.get("eventId") as! String
                let eventDescription = document.get("eventDescription") as! String
                //                let eventLocation = document.get("eventLocation") as! String
                let address = document.get("address") as! String

                let eventName = document.get("eventName") as! String
                let eventPoints = document.get("eventPoints") as! Int
                let eventType = document.get("eventType") as! String
                let eventAverageCost = document.get("eventAverageCost") as! Int
                let eventTime = document.get("eventTime") as! Int
                let eventRules = document.get("eventRules") as! String
                let eventMonth = document.get("eventMonth") as! String
                let eventURL = document.get("eventURL") as! String
                let eventOfferings = document.get("eventOfferings") as! String
                let eventTips = document.get("eventTips") as! String
                let eventTags = document.get("eventTags") as! [String]
                let eventIsTemp = document.get("isTempEvent") as! Bool
                
                let eventReviewPercentage = document.get("eventReviewPercentage") as! Double
                let eventTotalReviews = document.get("eventTotalReviews") as! Int
                
                let eventLocation = document.get("eventLocation") as! Bool
                let lastReview = document.get("lastReview") as! String
                let lastReviewName = document.get("lastReviewName") as! String
                let lastReviewDate = document.get("lastReviewDate") as! String
                let lastReviewScore = document.get("lastReviewScore") as! Int

//                let reviewDate = lastReviewDate.dateValue()
                
                let event : EventModel = EventModel(id: id, eventName: eventName, eventDescription: eventDescription, eventRules: eventRules,  eventAverageCost: eventAverageCost, eventTime: eventTime, eventPoints: eventPoints, eventType: eventType, eventMonth: eventMonth, eventURL: eventURL, eventOfferings: eventOfferings, eventTips: eventTips, eventTags: eventTags, isTemp: eventIsTemp, eventReviewPercentage: eventReviewPercentage, eventTotalReviews: eventTotalReviews,eventLocation: eventLocation,long:eventLong,lat:eventLat, distance:distance, lastReview: lastReview,lastReviewName: lastReviewName,lastReviewDate: lastReviewDate, lastReviewScore: lastReviewScore, address: address)
                
                let saved : SavedEvent = SavedEvent(event: event, teamName: eventId.teamName, note: eventId.note, date: eventId.date, eventId: eventId.eventId)
                editedEvents.append(saved)
                
                count += 1
                if maxCount == count {
                    onCompletion(.success(editedEvents))
                    return
                }
                
            }
            
        }
    }
    func reviewEvent(id:String, star:Double, onCompletion:@escaping(Result<Void,DomainError>)->()){
        
        db.collection("events_v1").document(id).getDocument { doc, error in
            guard let doc = doc, error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            var currentReviewTotal = doc.get("eventTotalReviews") as! Int
            var currentReviewPercentage = doc.get("eventReviewPercentage") as! Double
            
            currentReviewTotal += 1
            currentReviewPercentage += Double(star)
            
            self.db.collection("events_v1").document(id).updateData([
            
                "eventTotalReviews" : currentReviewTotal,
                "eventReviewPercentage" : currentReviewPercentage
            
            ])
            
            onCompletion(.success(()))
            return
        }
    }
    
//    func fetchTokens(id:String,onCompletion:@escaping(Result<Tokens,DomainError>)->()){
//        
//        db.collection("group_v2").document(id).getDocument { document, error in
//            guard let document = document, error == nil else {
//                onCompletion(.failure(.downloadError))
//                return
//            }
//            
//        }
//        
//    }
    
    func submitHostEvent(uploadedImage:UIImage,groupId:String,event:HostEvent,onCompletion:@escaping(Result<Void,DomainError>)->()){

//gs://mygameshow-63e93.appspot.com/hosted_events
        let fileName = event.eventId
        let data = uploadedImage.jpegData(compressionQuality: 0.6)!
        let ref = storage.child("hosted_events").child(groupId).child("\(fileName).jpg")
        
   

        
        ref.putData(data, metadata: nil) { (metadata, error) in
            guard let pictureMetadata = metadata else {
                onCompletion(.failure(.downloadError))
                return
            }
            ref.downloadURL { (URL, error) -> Void in
          guard let url = URL , error == nil else {
            // Handle any errors
              onCompletion(.failure(.uploadError))
              return
          }
              
              var urlUpdatedEvent = event
              urlUpdatedEvent.photoURL = url.absoluteString
            // Get the download URL for 'images/stars.jpg'
              self.db.collection("pending_events").document(event.eventId).setData(urlUpdatedEvent.dictionary)
              
              
              let hostRef = self.db.collection("hosted_events_v1").document(event.eventId)
              hostRef.setData(urlUpdatedEvent.dictionary)
              hostRef.updateData([
                "groupIDS" : []
                ,
                  "totalRSVP": 0,
                  "eventCost" : 0,
                  "eventTime" : 0,
                  "eventPoints" : 5
              ])
                hostRef.collection("RSVPS")
                

              
              onCompletion(.success(()))
          
        }
 
//            let groupRef = self.db.collection("group_v2").document(groupId)
            
    
        }
    }
    func submitHostEventAgain(uploadedImage:UIImage,groupId:String,event:HostEvent,onCompletion:@escaping(Result<Void,DomainError>)->()){
        
        
        let fileName = event.eventId + "/" + groupId + "/" + event.eventName
        let data = uploadedImage.jpegData(compressionQuality: 0.6)!
        let ref = storage.child("hosted_events").child(groupId).child("\(fileName).jpg")
        
        var urlUpdatedEvent = event
        urlUpdatedEvent.photoURL = fileName
        
        
        ref.putData(data, metadata: nil) { (metadata, error) in
            guard let pictureMetadata = metadata else {
                onCompletion(.failure(.downloadError))
                return
            }
 
//            let groupRef = self.db.collection("group_v2").document(groupId)
            
            self.db.collection("pending_events").document(event.eventId).setData(urlUpdatedEvent.dictionary)
            

            self.db.collection("hosted_events_v1").document(event.eventId).setData(urlUpdatedEvent.dictionary)
            self.db.collection("hosted_events_v1").document(event.eventId).updateData([
                "groupIDS" : []
                ,
                "totalRSVP": 0,
                "eventCost" : 0,
                "eventTime" : 0,
                "eventPoints" : 5
            ])
            self.db.collection("hosted_events_v1").document(event.eventId).collection("RSVP")
            onCompletion(.success(()))
        }
    }
    
    func fetchPendingEvents(groupId:String,onCompletion:@escaping(Result<[HostEvent],DomainError>)->()){
        let groupRef = db.collection("pending_events")
        
        groupRef.whereField("hostId", isEqualTo:groupId).getDocuments { query, error in
            guard let documents = query , error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            
            if documents.documents.count == 0 {
                onCompletion(.success([]))
                return
            }
            
            let maxDocs = documents.documents.count
            var count = 0
            
            var hostEvents : [HostEvent] = []
            
            for document in documents.documents {
                let decoder = JSONDecoder()
                var dict = document.data()
                for (key, value) in dict {
                    if let value = value as? Date {
                        let formatter = DateFormatter()
                        dict[key] = formatter.string(from:value)
                    }
                }
                let data = try? JSONSerialization.data(withJSONObject: dict, options:[])
                do{
                    let event = try decoder.decode(HostEvent.self, from: data!)
              
                    hostEvents.append(event)
                    count += 1
                    
                    if count == maxDocs {
                        onCompletion(.success(hostEvents))
                        return
                    }

                }
                catch{
                    print("error parsing this event")
                    count += 1
                    if count == maxDocs {
                        onCompletion(.success(hostEvents))
                        return
                    }
                    }
            }
            
            
        }
    }
    func fetchPendingConfirmedEvents(groupId:String,onCompletion:@escaping(Result<[HostEvent],DomainError>)->()){
        let groupRef = db.collection("hosted_events_v1")
        
        groupRef.whereField("hostId", isEqualTo:groupId).getDocuments { query, error in
            guard let documents = query , error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            
            if documents.documents.count == 0 {
                onCompletion(.success([]))
                return
            }
            
            let maxDocs = documents.documents.count
            var count = 0
            
            var hostEvents : [HostEvent] = []
            
            for document in documents.documents {
                let decoder = JSONDecoder()
                var dict = document.data()
                for (key, value) in dict {
                    if let value = value as? Date {
                        let formatter = DateFormatter()
                        dict[key] = formatter.string(from:value)
                    }
                }
                let data = try? JSONSerialization.data(withJSONObject: dict, options:[])
                do{
                    let event = try decoder.decode(HostEvent.self, from: data!)
                    
                    if event.isActive{
                        hostEvents.append(event)

                    }
              
                    count += 1
                    
                    if count == maxDocs {
                        onCompletion(.success(hostEvents))
                        return
                    }

                }
                catch{
                    print("error parsing this event")
                    count += 1
                    if count == maxDocs {
                        onCompletion(.success(hostEvents))
                        return
                    }
                    }
            }
            
            
        }
    }
    func fetchCompletedConfirmedEvents(groupId:String,onCompletion:@escaping(Result<[HostEvent],DomainError>)->()){
        let groupRef = db.collection("hosted_events_v1")
        
        groupRef.whereField("hostId", isEqualTo:groupId).getDocuments { query, error in
            guard let documents = query , error == nil else {
                onCompletion(.failure(.downloadError))
                return
            }
            
            if documents.documents.count == 0 {
                onCompletion(.success([]))
                return
            }
            
            let maxDocs = documents.documents.count
            var count = 0
            
            var hostEvents : [HostEvent] = []
            
            for document in documents.documents {
                let decoder = JSONDecoder()
                var dict = document.data()
                for (key, value) in dict {
                    if let value = value as? Date {
                        let formatter = DateFormatter()
                        dict[key] = formatter.string(from:value)
                    }
                }
                let data = try? JSONSerialization.data(withJSONObject: dict, options:[])
                do{
                    let event = try decoder.decode(HostEvent.self, from: data!)
              
                    if event.isCompleted{
                        hostEvents.append(event)

                    }
                    count += 1
                    
                    if count == maxDocs {
                        onCompletion(.success(hostEvents))
                        return
                    }

                }
                catch{
                    print("error parsing this event")
                    count += 1
                    if count == maxDocs {
                        onCompletion(.success(hostEvents))
                        return
                    }
                    }
            }
            
            
        }
    }
    func deletePendingEvent(id:String,groupId:String){
        
        db.collection("pending_events").document(id).delete()
        
        db.collection("hosted_events_v1").document(id).delete()
        
    }
    
     func fetchPicture(groupId:String,event:HostEvent, onCompletion: @escaping(Result<UIImage, DomainError>)->()){
         let fileName = event.eventId + "/" + groupId + "/" + event.eventName
         let ref = storage.child("hosted_events").child(groupId).child("\(fileName).jpg")

                                                                         
        ref.getData(maxSize: self.IMG_MAX_SIZE) { data, error in
                if error != nil {
                    onCompletion(.failure(.downloadError))
                } else {
                    onCompletion(.success(UIImage(data: data!)!))
                }
        }
    }
    
    func rsvpToEvent(RSVP: Bool, event:EventModel, onCompletion:@escaping(Result<Void,DomainError>)->()){
        
        if event.id.count > 10 {
            
            profileViewModel.fetchTeamWithoutID { result in
                switch result{
                case .success(let team):
                    let groupId = team.id
                    if groupId == "" {
                        onCompletion(.failure(.downloadError))
                            return
                    }
                    let eventRef = self.db.collection("hosted_events_v1").document(event.id)
                    
                    eventRef.getDocument { document, error in
                        guard let doc = document, error == nil else {
                            onCompletion(.failure(.downloadError))
                            return
                        }
                        var totalRSVP = doc.get("totalRSVP") as! Int
                        var groupIDS = doc.get("groupIDS") as! [String]
                        
                        if RSVP{
                            for id in groupIDS {
                                if id == groupId{
                                    onCompletion(.success(()))
                                    return
                                }
                            }
                            groupIDS.append(groupId)
                            eventRef.updateData([
                            
                                "totalRSVP" :  totalRSVP + 1 ,
                                "groupIDS" : groupIDS
                            
                            ])
                            eventRef.collection("RSVP").document(groupId).setData([
                                "groupId" : groupId,
                                "teamName" : team.teamName,
                                "eventName" : event.eventName
                            ])
                        }else{
                            var count = 0
                            for id in groupIDS {
                                if id == groupId{
                                    break
                                }
                                count += 1
                            }
                            if count == groupIDS.count {
                                onCompletion(.success(()))
                                return
                            }
                            groupIDS.remove(at: count)
                            eventRef.updateData([
                            
                                "totalRSVP" :  totalRSVP - 1 ,
                                "groupIDS" : groupIDS
                            
                            ])
                            eventRef.collection("RSVP").document(groupId).delete()
                            
                        }
                        onCompletion(.success(()))
                        return
                        
            
                }
                case .failure(let error):
                    print("error fetching team without ID \(error)")
                    onCompletion(.failure(.downloadError))
                    return
            }
           
               
            }
      
         
        

 
     
        }
       
    }
        
       

    
}

struct HeadLiners {
    
    let header : String
    let tags : [String]
    var events : [EventModel]
    
}


   




//}
//func updatePoints(pointsEarned: Int, onCompletion: @escaping (Result<Void,DomainError>)->()){
//
//    fetchGroupProfile(groupId: groupId!) { result in
//        switch result {
//        case .success(let group):
//            let points = group.points + pointsEarned
//            self.db.collection("group_v1").document(self.groupId!).updateData(["points" : points])
//            onCompletion(.success(()))
//
//        case .failure(let error):
//            print("Error retrieving group to update points \(error)")
//            onCompletion(.failure(.downloadError))
//        }
//    }
//

        
    
//}
//EVENT SUBMITTING PHOTOS
//func submitBasicEventPhotos(_ pic: UIImage, event: EventModel, onCompletion: @escaping (Result<Void,DomainError>) -> ()){
//    
//    if self.groupId == ""{
//        print("SELF GROUP ID IS EMPTY WHEN TRYING TO SUBMIT PHOTOS")
//        onCompletion(.failure(.downloadError))
//        return
//        
//    }
//    
//    let eventRef = storage.child("group_v1").child(self.groupId!).child("events_v1").child("basicEvents_v1").child("\(event.id)\(self.groupId!)")
//    let data = pic.jpegData(compressionQuality: 1.0)!
//    let picRef = eventRef.child("event_pic_\(event.id).jpg")
//    picRef.putData(data, metadata: nil) { (metadata, error) in
//        guard metadata != nil else {
//            onCompletion(.failure(.downloadError))
//            return
//        }
//        self.submitFireEvent(event: event, onCompletion: onCompletion)
//    }
//    return
//}
//func submitFireEvent(event: EventModel,  onCompletion:@escaping (Result<Void,DomainError>)->()){
//    
//    db.collection("group_v1").document(self.groupId!).collection("group_events_v1").document(event.id).setData(
//                            [
//                                "id" : event.id,
//                                "eventName" : event.eventName,
//                                "eventPoints" : event.eventPoints,
//                                "eventCompleted" : true,
//                                "timestamp" : FieldValue.serverTimestamp()
//                            ])
//    updatePoints(pointsEarned: event.eventPoints, onCompletion: onCompletion)
//    
//    return
//}
//func checkIfGroupCanSubmit(event: EventModel, onCompletion: @escaping (Result<Bool,DomainError>)->()){
//    
//    print("GROUP ID IN CHECK IF CAN SUBMIT \(self.groupId!)")
//    let eventRef = db.collection("group_v1").document(self.groupId!).collection("group_events_v1")
//    eventRef.document(event.id).getDocument { document, error in
//        guard error == nil else {
//            print("error", error ?? "")
//            onCompletion(.failure(.downloadError))
//            return
//        }
//        if let document = document, document.exists {
//            
//
//            
//            onCompletion(.success(false))
//            return
//        }
//        
//        else{
//            onCompletion(.success(true))
//            return
//        }
//    }
//}



//}
