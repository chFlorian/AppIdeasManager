// Created by Florian Schweizer on 07.06.23

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query var ideas: [AppIdea]
  
  @State private var showAddDialog = false
  @State private var newName = ""
  @State private var newDescription = ""
  
  var body: some View {
    NavigationStack {
      List(ideas) { idea in
        NavigationLink(value: idea) {
          VStack(alignment: .leading) {
            Text(idea.name)
            
            Text(idea.detailedDescription)
              .textScale(.secondary)
              .foregroundStyle(.secondary)
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
