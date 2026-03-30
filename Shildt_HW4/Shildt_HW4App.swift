//
//  Shildt_HW4App.swift
//  Shildt_HW4
//
//  Created by Greg Shildt on 3/27/26.
//

import SwiftUI
internal import CoreData

@main
struct BookSearchAppApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

