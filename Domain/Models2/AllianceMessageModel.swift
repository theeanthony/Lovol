//
//  AllianceMessageModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/26/23.
//

import Foundation
struct AllianceMessageModel: Identifiable, Equatable{
    let id: String
    let isCurrentUser: Bool
    let timestamp: Date
    let message: String
    let name: String
    
    static func from(id: String, _ msg: FirestoreMessage, currentUserId: String, name: String) -> MessageModel{
        return MessageModel(id: id, isCurrentUser: msg.senderId == currentUserId, timestamp: msg.timestamp, message: msg.message, name: msg.senderName, senderId: msg.senderId)
    }
}

//["message" : message,
// "senderId" : self.userId!,
// "timestamp" : FieldValue.serverTimestamp(),
// "senderName" : user.name,
// "recipientId" : matchId
