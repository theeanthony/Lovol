//
//  ChatModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 2/26/23.
//

import Foundation
import SwiftUI
 
struct ChatModel: Identifiable{
    let id: String
    let groupId: String
    let name: String
    
    var picture: UIImage
    let lastMessage: String?
    

}
