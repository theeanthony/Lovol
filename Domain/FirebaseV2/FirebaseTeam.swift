//
//  FirebaseTeam.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/17/23.
//

import Foundation
import SwiftUI
struct FirebaseTeam : Identifiable{
    
    let id : String
    let teamName : String
    let teamDescription: String
    let teamRule : Bool
//    let teamProfilePic : UIImage
    let teamPoints : Int
    
    let teamMemberNames : [String]
    let teamMemberRoles : [String]
    let teamMemberIDS :[String]
    //change to collection 
//    let teamPics : [UIImage]
    
    let suggestedEvents : [String]
    let chosenEvent : String
    
    let requests : [String]
    //differentiate between teams and solo accounts
    let achievements: [String]
    let alliances : [String]
    
    let exists: Bool
    
    let setTimeForChosenEvent : String
    
    let teamLovols : Int
    
    let lifeTimeLovols : Int
    
    let city: String
    let long  : Double
    let lat : Double
    
    let timeCreated : String
    
    let locationSet : Bool
    
    let address : String
    
    let lifetimeLovolBits : Int
    
    let totalEventsCompleted : Int
    
    let multiplier : Int
    let resurrection : Int
    let isMember : Bool
    
    init(){
        self.id = ""
        self.teamName = ""
        self.teamDescription = ""
        self.teamRule = false
        self.teamPoints = 0
        self.teamMemberNames = []
        self.teamMemberRoles = []
        self.teamMemberIDS = []
        self.suggestedEvents = []
        self.chosenEvent = ""
        self.requests = []
        self.achievements = []
        self.alliances = []
        self.exists = true
        self.setTimeForChosenEvent = ""
        self.teamLovols = 0
        self.lifeTimeLovols = 0
        self.city = ""
        self.long = 0
        self.lat = 0
        self.timeCreated = ""
        self.locationSet = false
        self.address = ""
        self.lifetimeLovolBits = 0
        self.totalEventsCompleted = 0
        self.multiplier = 0
        self.resurrection = 0
        self.isMember = false 
        
    }
    init(id:String,teamName:String,teamDescription:String,teamRule:Bool,teamPoints:Int,teamMemberNames:[String],teamMemberRoles:[String],teamMemberIDS:[String],suggestedEvents:[String],chosenEvent:String,requests:[String],achievements:[String],alliances:[String],exists:Bool,setTimeForChosenEvent:String,teamLovols:Int,lifeTimeLovols:Int,city:String,long:Double,lat:Double,timeCreated:String,locationSet:Bool,address:String,lifetimeLovolBits:Int,totalEventsCompleted:Int,multiplier:Int,resurrection:Int,isMember:Bool){
        self.id = id
        self.teamName = teamName
        self.teamDescription = teamDescription
        self.teamRule = teamRule
        self.teamPoints = teamPoints
        self.teamMemberNames = teamMemberNames
        self.teamMemberRoles = teamMemberRoles
        self.teamMemberIDS = teamMemberIDS
        self.suggestedEvents = suggestedEvents
        self.chosenEvent = chosenEvent
        self.requests = requests
        self.achievements = achievements
        self.alliances = alliances
        self.exists = exists
        self.setTimeForChosenEvent = setTimeForChosenEvent
        self.teamLovols = teamLovols
        self.lifeTimeLovols = lifeTimeLovols
        self.city = city
        self.long = long
        self.lat = lat
        self.timeCreated = timeCreated
        self.locationSet = locationSet
        self.address = address
        self.lifetimeLovolBits = lifetimeLovolBits
        self.totalEventsCompleted = totalEventsCompleted
        self.multiplier = multiplier
        self.resurrection = resurrection
        self.isMember = isMember
    }
    
    
//achievementModels
    //allianceModels
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
   
    
    
}
extension FirebaseTeam: Codable {
        enum CodingKeys: String, CodingKey {
            case id
            case teamName
            case teamDescription
            case teamRule
            case teamPoints
            case teamMemberNames
            case teamMemberRoles
            case teamMemberIDS
            case suggestedEvents
            case chosenEvent
            case requests
            case achievements
            case alliances
          case exists
            case setTimeForChosenEvent
            case teamLovols
            case lifeTimeLovols
            
            case city
            case long
            case lat
            case timeCreated
            
            case locationSet
            
            case address
            case lifetimeLovolBits
            case totalEventsCompleted
            
            case multiplier
            case resurrection
            case isMember
//            case chosenTime 
//            case teamPic
            
        }
    }


// amountOfHostedEvents
// eventHostRating
// isHosting
//verified
