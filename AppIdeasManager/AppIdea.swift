// Created by Florian Schweizer on 07.06.23

import SwiftUI
import SwiftData

@Model
class AppIdea {
  @Attribute(.unique) var name: String
  var detailedDescription: String
  var creationDate: Date
  var isArchived: Bool = false
  var isFavorite: Bool = false
  
  init(name: String, detailedDescription: String, isArchived: Bool = false, isFavorite: Bool = false) {
    self.name = name
    self.detailedDescription = detailedDescription
    self.creationDate = .now
    self.isArchived = isArchived
    self.isFavorite = isFavorite
  }
  
  @Relationship(.cascade)
  var features: [AppFeature] = []
}
