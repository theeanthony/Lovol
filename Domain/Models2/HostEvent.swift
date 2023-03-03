//
//  HostEvent.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/21/23.
//

import Foundation
import SwiftUI

struct HostEvent{
    
    let hostId : String 
    let eventId : String
    let eventName : String
    let eventDescription: String
    let eventRules : String
    let eventTips:String
    let eventOfferings : String
    
    let eventAddress : String
    let eventCityName:String
    let eventLongCoord :Double
    let eventLatCoord : Double
    let eventStartTime : Date
    let eventEndTime : Date
    let eventTags : [String]
    let exclusivity : Int
    let eventFee : String
    let over21 : Bool
        
    var photoURL : String
    let note : String
    
    let isActive : Bool
    
    let isRejected : Bool
    let isCompleted: Bool
    
    let eventMonth : String
    
    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    
    
}
extension HostEvent: Codable {
    enum CodingKeys: String, CodingKey{
        case hostId
        case eventId
        case eventName
        case eventDescription
        case eventRules
        case eventTips
        case eventOfferings
        case eventAddress
        case eventCityName
        case eventLongCoord
        case eventLatCoord
        case eventStartTime
        case eventEndTime
        case eventTags
        case exclusivity
        case eventFee
        case over21
        case photoURL
        case note
        case isActive
        case isRejected
        case isCompleted
        case eventMonth
    }
}

struct ConfirmedHostEvent {
    
    
    let hostEvent : HostEvent
    
    let groupIDS : [String]
    
    let image : UIImage
    
    let eventCost : Int
    
    let eventTime : Int
    
    let eventPoints : Int 
}
