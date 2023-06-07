// Created by Florian Schweizer on 07.06.23

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var ideas: [AppIdea]
  
  @State private var showAddDialog = false
  @State private var newIdeaName = ""
  @State private var newIdeaDescription = ""
  
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
            TextField("App Name", text: $newIdeaName)
            
            TextField("Description", text: $newIdeaDescription, axis: .vertical)
              .lineLimit(5, reservesSpace: true)
          }
          .navigationTitle("Add App Idea")
          .toolbar {
            Button("Dismiss", role: .cancel) {
              showAddDialog.toggle()
            }
            
            Button("Save") {
              guard newIdeaName.isEmpty == false else { return }
              
              let idea = AppIdea(name: newIdeaName, detailedDescription: newIdeaDescription)
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
    .modelContainer(for: AppIdea.self, inMemory: true)
}
