//
//  RequestModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/26/22.
//

import Foundation
import SwiftUI

struct RequestModel: Identifiable, Equatable {
    static func == (lhs: RequestModel, rhs: RequestModel) -> Bool {
        return lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
     }
    let id: String
    let sendingRequestId: String
    let nameOfSender: String
    let groupId: String
    let sendRole: String
    let isATeam : Bool 
    
}
struct RequestModelPicture {
    static func == (lhs: RequestModelPicture, rhs: RequestModelPicture) -> Bool {
        return lhs.request.id == rhs.request.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(request.id)
     }
    let request : RequestModel
    
    let pic : UIImage
    
}

