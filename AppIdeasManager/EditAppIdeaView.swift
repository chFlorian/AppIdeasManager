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
        .lineLimit(10, reservesSpace: true)
      
      Section("Feature") {
        TextField("New Feature", text: $newFeatureDescription)
          .onSubmit {
            let feature = AppFeature(detailedDescription: newFeatureDescription)
            idea.features.append(feature)
            newFeatureDescription.removeAll()
          }
        
        ForEach(idea.features) { feature in
          Text(feature.detailedDescription)
        }
      }
    }
    .navigationTitle(idea.name)
    .toolbar {
      Button("Delete", role: .destructive) {
        modelContext.delete(idea)
        dismiss()
      }
    }
  }
}
