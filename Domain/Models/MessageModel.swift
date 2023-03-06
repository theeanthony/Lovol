//
//  MessageModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/21/22.
//
 
import Foundation

struct MessageModel: Identifiable, Equatable{
    let id: String
    let isCurrentUser: Bool
    let timestamp: String?
    let message: String
    let name: String
    
    static func from(id: String, _ msg: FirestoreMessage, currentUserId: String, name: String) -> MessageModel{
        return MessageModel(id: id, isCurrentUser: msg.senderId == currentUserId, timestamp: msg.timestamp, message: msg.message, name: msg.senderName)
    }
}
//struct MessageAllianceModel: Identifiable, Equatable{
//    let id: String
//    let isCurrentUser: Bool
//    let timestamp: String
//    let message: String
//    let name: String
//
//    static func from(id: String, _ msg: FirestoreAllianceMessage, currentUserId: String, name: String) -> MessageAllianceModel{
//        return MessageAllianceModel(id: id, isCurrentUser: msg.senderId == currentUserId, timestamp: msg.timestamp, message: msg.message, name: msg.senderName)
//    }
//}
