// Created by Florian Schweizer on 07.06.23

import SwiftUI
import SwiftData

struct EditAppIdeaView: View {
  @Environment(\.modelContext) private var modelContext
  @Environment(\.dismiss) var dismiss
  @Bindable var idea: AppIdea
  
  @State private var newFeatureDescription = ""
  
  var body: some View {
    Form {
      TextField("Name", text: $idea.name)
      
      TextField("Description", text: $idea.detailedDescription, axis: .vertical)
      
      Section("Features") {
        TextField("New Feature", text: $newFeatureDescription)
          .onSubmit {
            let feature = AppFeature(detailedDescription: newFeatureDescription)
            idea.features.append(feature)
            newFeatureDescription.removeAll()
          }
        
        ForEach(idea.features) { feature in
          Text(feature.detailedDescription)
            .contextMenu {
              Button(role: .destructive) {
                idea.features.removeAll(where: { $0.detailedDescription == feature.detailedDescription })
                modelContext.delete(feature)
              } label: {
                Label("Delete", systemImage: "trash")
              }
            }
        }
      }
    }
    .navigationTitle(idea.name)
  }
}
