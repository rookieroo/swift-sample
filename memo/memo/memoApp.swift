//
//  memoApp.swift
//  memo
//
//  Created by chris on 2024/11/25.
//

import SwiftUI

@main
struct memoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
