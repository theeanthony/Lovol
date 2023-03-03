//
//  EventModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/3/22.
//

import Foundation
import SwiftUI


 
struct EventModel:  Equatable, Identifiable{
   
    var id : String
    var eventName: String
    var eventDescription: String
    var eventRules : String
    
    var eventLocation : Bool
    var eventAverageCost: Int
    var eventTime: Int
    var eventPoints: Int
    
    var eventType : String
    
    var eventMonth: String
    var eventCompleted : Bool? = false
    var eventURL : String
    
    var eventOfferings :String
    var eventTips : String
    var alliancesExclusive : Bool? 
    
    var timeDone : Date?
    var eventReviewPercentage : Double
    var eventTotalReviews : Int
    var writtenReviews : [String]?
    var isTempEvent : Bool
    var eventTags : [String]
    var startingTime : Date?
    
    var endingTime : Date?
    var totalRSVP : Int?
    var groupIDS : [String]?
    var note : String?
    var didISave : Bool? = false
    
    
    var long : Double
    var lat: Double
    
    var distance : Double?
    
    var didIRSVP : Bool?
    
    var lastReview : String
    var lastReviewName : String
    var lastReviewDate : String
    var lastReviewScore : Int
    
    var address : String
    
    
    init(id:String,eventName:String,eventDescription:String,eventRules:String,eventAverageCost:Int,eventTime:Int, eventPoints: Int,eventType : String,eventMonth: String,eventURL : String,eventOfferings :String,eventTips : String,eventTags:[String], isTemp:Bool, eventReviewPercentage: Double, eventTotalReviews: Int, eventLocation:Bool, long:Double,lat:Double, lastReview:String,lastReviewName:String, lastReviewDate:String, lastReviewScore:Int, address:String){
        self.id = id
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.eventRules = eventRules
        self.eventAverageCost = eventAverageCost
        self.eventTime = eventTime
        self.eventPoints = eventPoints
        self.eventType = eventType
        self.eventMonth = eventMonth
        self.eventURL = eventURL
        self.eventOfferings = eventOfferings
        self.eventTips = eventTips
        self.eventTags = eventTags
        self.isTempEvent = isTemp
        self.eventReviewPercentage = eventReviewPercentage
        self.eventTotalReviews = eventTotalReviews
        self.eventLocation = eventLocation
        self.long = long
        self.lat = lat
        self.lastReview = lastReview
        self.lastReviewName = lastReviewName
        self.lastReviewDate = lastReviewDate
        self.lastReviewScore = lastReviewScore
        self.address = address 

//        self.didISave = didISave
    }
    init(id:String,eventName:String,eventDescription:String,eventRules:String,eventAverageCost:Int,eventTime:Int, eventPoints: Int,eventType : String,eventMonth: String,eventURL : String,eventOfferings :String,eventTips : String,eventTags:[String], isTemp:Bool, eventReviewPercentage: Double, eventTotalReviews: Int, eventLocation:Bool, long:Double,lat:Double,distance:Double, lastReview:String,lastReviewName:String, lastReviewDate:String, lastReviewScore:Int,address:String){
        self.id = id
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.eventRules = eventRules
        self.eventAverageCost = eventAverageCost
        self.eventTime = eventTime
        self.eventPoints = eventPoints
        self.eventType = eventType
        self.eventMonth = eventMonth
        self.eventURL = eventURL
        self.eventOfferings = eventOfferings
        self.eventTips = eventTips
        self.eventTags = eventTags
        self.isTempEvent = isTemp
        self.eventReviewPercentage = eventReviewPercentage
        self.eventTotalReviews = eventTotalReviews
        self.eventLocation = eventLocation
        self.long = long
        self.lat = lat
        self.distance = distance
        self.lastReview = lastReview
        self.lastReviewName = lastReviewName
        self.lastReviewDate = lastReviewDate
        self.lastReviewScore = lastReviewScore
        self.address = address

//        self.didISave = didISave
    }
    
    init(id:String,eventName:String,eventDescription:String,eventRules:String,eventAverageCost:Int,eventTime:Int, eventPoints: Int,eventType : String,eventMonth: String,eventURL : String,eventOfferings :String,eventTips : String,eventTags:[String], isTemp:Bool, eventReviewPercentage: Double, eventTotalReviews: Int, eventLocation:Bool, long:Double,lat:Double,distance:Double, totalRSVP: Int, startingTime: Date, endingTime:Date, note:String, groupIDS: [String ], didIRSVP:Bool, lastReview:String,lastReviewName:String, lastReviewDate:String, lastReviewScore:Int, address:String){
        self.id = id
        self.eventName = eventName
        self.eventDescription = eventDescription
        self.eventRules = eventRules
        self.eventAverageCost = eventAverageCost
        self.eventTime = eventTime
        self.eventPoints = eventPoints
        self.eventType = eventType
        self.eventMonth = eventMonth
        self.eventURL = eventURL
        self.eventOfferings = eventOfferings
        self.eventTips = eventTips
        self.eventTags = eventTags
        self.isTempEvent = isTemp
        self.eventReviewPercentage = eventReviewPercentage
        self.eventTotalReviews = eventTotalReviews
        self.eventLocation = eventLocation
        self.long = long
        self.lat = lat
        self.distance = distance
        self.totalRSVP = totalRSVP
        self.startingTime = startingTime
        self.endingTime = endingTime
        self.note = note
        self.groupIDS = groupIDS
        self.didIRSVP = didIRSVP
        self.lastReview = lastReview
        self.lastReviewName = lastReviewName
        self.lastReviewDate = lastReviewDate
        self.lastReviewScore = lastReviewScore
        self.address = address
    }
    
    init(){
        self.id = ""
        self.eventName = ""
        self.eventDescription = ""
        self.eventRules = ""
        self.eventLocation = false
        self.eventAverageCost = 0
        self.eventTime = 0
        self.eventPoints = 0
        self.eventType = ""
        self.eventMonth = ""
        self.eventURL = ""
        self.eventOfferings = ""
        self.eventTips = ""
        self.eventTags = []
        self.isTempEvent = false
        self.eventReviewPercentage = 0
        self.eventTotalReviews = 0
        self.long = 0
        self.lat = 0
        
        self.lastReview = ""
        self.lastReviewName = ""
        self.lastReviewDate = ""
        self.lastReviewScore = 0
        self.address = ""
    }
    
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}


struct ResponseData : Codable {
    let events : [EventModel]
    

}
func loadJson() -> [EventModel] {
        print("Loading events")
        if let url = Bundle.main.url(forResource: "events", withExtension: "json") {
            do {
                print("do")
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                print("returning")
                return jsonData.events
            } catch {
                print("error:\(error)")
            }
        }
        return []
}


extension EventModel: Codable {
        enum CodingKeys: String, CodingKey {
            
            case id
            case eventName
            case eventDescription
            case eventRules
            case eventLocation
            case eventAverageCost
            case eventTime
            case eventPoints
            case eventType
            case eventMonth
            case eventCompleted
            case eventURL
            case eventOfferings
            case eventTips
            case timeDone
            case eventReviewPercentage
            case eventTotalReviews
            case writtenReviews
            case isTempEvent
            case eventTags
   
            case startingTime
            case endingTime
            case totalRSVP
            case groupIDS
            case note

            case didISave
            
            case long
            case lat
            
            case distance
            case didIRSVP
            case lastReview
            case lastReviewName
            case lastReviewDate
            case lastReviewScore
            case address
            
//            case suggested
    
            
        }
    }



struct EventModelWithLikes:  Equatable{
   
    let event : EventModel
    let likes : Int
    let chosen : Bool
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
}


extension EventModelWithLikes: Codable {
        enum CodingKeys: String, CodingKey {
            
            case event
            case likes
            case chosen
    
            
        }
    }
