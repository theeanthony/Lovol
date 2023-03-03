//
//  NewUsers.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/10/22.
//

import Foundation
import UIKit


struct NewUserProfile : Hashable {
    static func == (lhs: NewUserProfile, rhs: NewUserProfile) -> Bool {
        return lhs.userId == rhs.userId
    }
    func hash(into hasher: inout Hasher) {
         hasher.combine(userId)
     }
    
    let userId: String
    let name: String
    let age: Int
    let bio: String
    let amountOfUsers: Int
    let isATeam : Bool
    let interests : [String]
    let college: String
    let occupation: String

    let formPreference : Int
    let interactionPreference: Int
    let maxDistancePreference : Double
    let maxYearPreference : Int
    let minYearPreference: Int
    
    let answersToGlobalQuestions: [Int]
    let ownQuestions: [String]
    let ownLeftAnswer: [String]
    let ownRightAnswer: [String]
    let pictures: [UIImage]
    
    let nameAndPic : [NameAndProfilePic]?
    let city: String
    
}
