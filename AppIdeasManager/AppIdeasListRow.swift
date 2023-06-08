// Created by Florian Schweizer on 07.06.23

import SwiftUI
import SwiftData

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
    .contextMenu {
      Button(role: .destructive) {
        modelContext.delete(idea)
      } label: {
        Label("Delete", systemImage: "trash")
      }
    }
    .swipeActions {
      Button {
        idea.isArchived = true
      } label: {
        Label("Archive", systemImage: "archivebox")
          .tint(.orange)
      }
    }
    .sensoryFeedback(.impact, trigger: idea.isArchived)
  }
}
