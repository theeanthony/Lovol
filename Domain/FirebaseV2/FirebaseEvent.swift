//
//  FirebaseEvent.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/2/23.
//

import Foundation
import SwiftUI
struct FirebaseEvent : Identifiable{
    
    let id : String
    let event : EventModel
    
    var eventReviews : Double
//
    var eventTotalReviews : Int

    var writtenReviews : [String]

    var isTempEvent : Bool
//
    var startingTime : Date?
    var endingTime : Date?
//
    var totalRSVP : Int?

    var didISave : Bool?

    var long: Double?
    var lat: Double?
    //savers in firebase

    var dictionary: [String: Any] {
        let data = (try? JSONEncoder().encode(self)) ?? Data()
        return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
   
    
    
}
extension FirebaseEvent: Codable {
        enum CodingKeys: String, CodingKey {
            case id
            case event
            case eventReviews
            case eventTotalReviews
            case writtenReviews
            case isTempEvent
//            case eventTags
            case startingTime
            case endingTime
            case totalRSVP
            case didISave
            case long
            case lat
        }
    }
