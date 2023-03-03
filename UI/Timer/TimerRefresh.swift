//
//  TimerRefresh.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 11/27/22.
//

import Foundation

class RefreshManager: NSObject {

    static let shared = RefreshManager()
    private let defaults = UserDefaults.standard
    private let defaultsKey = "lastRefresh"
    private let calender = Calendar.current

    func loadDataIfNeeded(completion: (Bool) -> Void) {

        if isRefreshRequired() {
            // load the data
            defaults.set(Date(), forKey: defaultsKey)
            completion(true)
        } else {
            completion(false)
        }
    }

    private func isRefreshRequired() -> Bool {

        guard let lastRefreshDate = defaults.object(forKey: defaultsKey) as? Date else {
            return true
        }

        if let diff = calender.dateComponents([.hour], from: lastRefreshDate, to: Date()).hour, diff > 24 {
            return true
        } else {
            return false
        }
    }
}
