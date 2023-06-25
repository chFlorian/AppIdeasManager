// Created by Florian Schweizer on 09.06.23

import AppIntents
import SwiftData

struct ToggleFavoriteIntent: AppIntent {
  static var title: LocalizedStringResource = "AppIdea Intents"
  
  @Parameter(title: "App Idea")
  var ideaName: String
  
  init() {
    ideaName = ""
  }
  
  init(name: String) {
    self.ideaName = name
  }
  
  func perform() async throws -> some IntentResult {
    if let idea = try await getIdea() {
      idea.isFavorite.toggle()
      
      return .result()
    } else {
      return .result()
    }
  }
  
  let modelContainer = try! ModelContainer(
    for: [AppIdea.self, AppFeature.self],
    ModelConfiguration(sharedAppContainerIdentifier: "group.de.flowritesco.AppIdeasManagerTest")
  )
  
  @MainActor func getIdea() throws -> AppIdea? {
    let fetchDescriptor = FetchDescriptor<AppIdea>(
      predicate: #Predicate { $0.name == ideaName }
    )
    let ideas = try modelContainer.mainContext.fetch(fetchDescriptor)
    
    return ideas.first(
      where: { $0.name == ideaName }
    )
  }
}
