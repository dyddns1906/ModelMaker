//
//  ModelMakerApp.swift
//  ModelMaker
//
//  Created by Yongun Lim on 2023/02/05.
//

import SwiftUI

@main
struct ModelMakerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
