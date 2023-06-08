// Created by Florian Schweizer on 07.06.23

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(
    filter: #Predicate {
      $0.isArchived == false
    },
    sort: \.creationDate,
    order: .reverse
  ) var ideas: [AppIdea]
  
  @State private var showAddDialog = false
  @State private var newName = ""
  @State private var newDescription = ""
  
  var body: some View {
    NavigationStack {
      Group {
        if ideas.isEmpty {
          ContentUnavailableView(
            "No App Ideas",
            systemImage: "square.stack.3d.up.slash",
            description: Text("Add an app idea to get started.")
          )
        } else {
          List(ideas) {
            AppIdeasListRow(idea: $0)
          }
        }
      }
      .navigationTitle("App Ideas")
      .navigationDestination(for: AppIdea.self) { EditAppIdeaView(idea: $0) }
      .toolbar {
        Button("Add") {
          showAddDialog.toggle()
        }
      }
      .sheet(isPresented: $showAddDialog) {
        NavigationStack {
          Form {
            TextField("Name", text: $newName)
            TextField("Description", text: $newDescription, axis: .vertical)
          }
          .navigationTitle("New App Idea")
          .toolbar {
            Button("Dismiss") {
              showAddDialog.toggle()
            }
            
            Button("Save") {
              let idea = AppIdea(name: newName, detailedDescription: newDescription)
              modelContext.insert(idea)
              showAddDialog.toggle()
            }
          }
        }
        .presentationDetents([.medium])
      }
    }
  }
}

#Preview {
  ContentView()
    .modelContainer(for: [AppIdea.self, AppFeature.self], inMemory: true)
}
