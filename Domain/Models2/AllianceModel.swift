//
//  AllianceModel.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 1/27/23.
//

import Foundation
import SwiftUI

struct AllianceModel : Hashable {
    static func == (lhs: AllianceModel, rhs: AllianceModel) -> Bool {
        return lhs.groupId == rhs.groupId
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(groupId)
     }
    let groupId : String
    let teamName : String
    let teamDescription : String
    var memberModel : [MemberModel]
    var teamPic : UIImage 
//    let teamMemberIDS : [String]
//    let teamMemberNames : [String]
//    let teamMemberRoles: [String]
//    let teamMemberPics : [UIImage]
    
}
