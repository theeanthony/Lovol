//
//  FirestoreUserMatchData.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/9/22.
//

import Foundation

struct FirestoreMatchData{
    
    let leftAnswers : [Int]
    let leftQuestions: [String]
    let leftRightExamples: [String]

    let leftLeftExamples: [String]
//    let rightAnswers : [Int]
//    let rightLeftExamples: [String]
//    let rightQuestions: [String]
//    let rightRightExamples: [String]
    
//    let rightQuestions: [String]
//    let rightLeftExamples: [String]
//    let RightRightExamples: [String]
//    let RightAnswers : [Int]
    


    var dictionary: [String: Any] {
           let data = (try? JSONEncoder().encode(self)) ?? Data()
           return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
       }
    
    
}

extension FirestoreMatchData: Codable {
    enum CodingKeys: String, CodingKey {
        case leftAnswers
        case leftLeftExamples
        case leftQuestions
        case leftRightExamples
//        case rightAnswers
//        case rightLeftExamples
//        case rightQuestions
//        case rightRightExamples

    }
}
