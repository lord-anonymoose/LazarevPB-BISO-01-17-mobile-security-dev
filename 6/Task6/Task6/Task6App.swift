//
//  Task6App.swift
//  Task6
//
//  Created by Philipp on 26.01.2022.
//

import SwiftUI

@main
struct Task6App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
