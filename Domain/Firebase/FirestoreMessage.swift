//
//  FirestoreMessage.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/21/22.
//

import Foundation

struct FirestoreMessage: Codable{
    let message: String
    let timestamp: String?
    let senderId: String
    let senderName: String
//    let recipientId:String
}
 
 
