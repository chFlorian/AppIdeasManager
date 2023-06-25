// Created by Florian Schweizer on 10.06.23

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), ideas: [])
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    Task {
      let ideas = try await getIdeas()
      let entry = SimpleEntry(date: Date(), ideas: ideas)
      completion(entry)
    }
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    Task {
      var entries: [SimpleEntry] = []
      
      let ideas = try await getIdeas()
      let entry = SimpleEntry(date: Date(), ideas: ideas)
      entries.append(entry)
      
      let timeline = Timeline(entries: entries, policy: .after(.now.addingTimeInterval(60 * 5)))
      completion(timeline)
    }
  }
  
  @MainActor func getIdeas() throws -> [AppIdea] {
    let modelContainer = try ModelContainer(
      for: [AppIdea.self,
            AppFeature.self],
      ModelConfiguration(sharedAppContainerIdentifier: "group.de.flowritesco.AppIdeasManagerTest")
    )
    let fetchDescriptor = FetchDescriptor<AppIdea>(
      predicate: #Predicate { $0.isArchived == false }
    )
    let ideas = try modelContainer.mainContext.fetch(fetchDescriptor).sorted(by: { $0.name < $1.name })
    
    return ideas
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let ideas: [AppIdea]
}

struct AppIdea_WIdgetsEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    VStack {
      Text("Count: \(entry.ideas.count, format: .number)")
      
      ForEach(entry.ideas) { idea in
        Button(intent: ToggleFavoriteIntent(name: idea.name)) {
          HStack {
            Image(systemName: idea.isFavorite ? "star.fill" : "star")
              .foregroundStyle(.yellow)
            
            Text(idea.name)
            
            Spacer()
          }
        }
      }
    }
    .containerBackground(.fill.tertiary, for: .widget)
  }
}

struct AppIdea_WIdgets: Widget {
  let kind: String = "AppIdea_WIdgets"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      AppIdea_WIdgetsEntryView(entry: entry)
        .modelContainer(try! ModelContainer(for: [AppIdea.self, AppFeature.self], ModelConfiguration(sharedAppContainerIdentifier: "group.de.flowritesco.AppIdeasManagerTest")))
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

#Preview(as: .systemSmall) {
  AppIdea_WIdgets()
} timeline: {
  SimpleEntry(date: .now, ideas: [])
  SimpleEntry(date: .now, ideas: [])
}
