// Created by Florian Schweizer on 07.06.23

import SwiftUI
import SwiftData

@main
struct AppIdeasManagerApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [AppIdea.self, AppFeature.self])
    }
}
