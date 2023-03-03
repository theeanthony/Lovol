//
//  ErrorHandler.swift
//  lovol_v2 (iOS)
//
//  Created by Anthony Contreras on 10/19/22.
//

import Foundation

@MainActor
protocol StateManager: AnyObject {
    var error: Error? { get set }
    var isWorking: Bool { get set }

}
 
extension StateManager {
    typealias Action = () async throws -> Void
    private func withStateManagement(perform action: @escaping Action) async {
        isWorking = true
        do {
            try await action()
        } catch {
            print("[\(Self.self)] Error: \(error)")
            self.error = error
        }
        isWorking = false
    }
    nonisolated func withStateManagingTask(perform action: @escaping () async throws -> Void) {
        Task {
            await withStateManagement(perform: action)

        }
    }
}
extension StateManager {
    var isWorking: Bool {
        get { false }
        set {}
    }
}
