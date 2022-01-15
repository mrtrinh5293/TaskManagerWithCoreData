//
//  TaskManagerCoreDataApp.swift
//  TaskManagerCoreData
//
//  Created by duc on 2022-01-12.
//

import SwiftUI

@main
struct TaskManagerCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
