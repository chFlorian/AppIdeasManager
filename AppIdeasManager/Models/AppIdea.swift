// Created by Florian Schweizer on 07.06.23

import SwiftUI
import SwiftData

@Model
class AppIdea {
  @Attribute(.unique) var name: String
  var detailedDescription: String
  var creationDate: Date
  
  init(name: String, detailedDescription: String) {
    self.name = name
    self.detailedDescription = detailedDescription
    self.creationDate = .now
  }
  
  @Relationship(.cascade)
  var features: [AppFeature] = []
}
