// Created by Florian Schweizer on 09.06.23

import SwiftUI

struct AppIdeasListRow: View {
  @Environment(\.modelContext) private var modelContext
  var idea: AppIdea
  
  var body: some View {
    NavigationLink(value: idea) {
      VStack(alignment: .leading) {
        Text(idea.name)
        
        Text(idea.detailedDescription)
          .textScale(.secondary)
          .foregroundStyle(.secondary)
      }
    }
    .swipeActions {
      Button(role: .destructive) {
        idea.isArchived = true
      } label: {
        Label("Archive", systemImage: "archivebox")
      }
    }
    .sensoryFeedback(.decrease, trigger: idea.isArchived)
  }
}
