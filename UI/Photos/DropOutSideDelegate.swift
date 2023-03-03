//
//  DropOutSideDelegate.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/19/22.
//

import SwiftUI

struct DropOutsideDelegate: DropDelegate {
    @Binding var droppedOutside: Bool
        
    func performDrop(info: DropInfo) -> Bool {
        droppedOutside = true
        return true
    }
}
