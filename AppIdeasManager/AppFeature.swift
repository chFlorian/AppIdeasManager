// Created by Florian Schweizer on 07.06.23

import SwiftUI
import SwiftData

@Model
class AppFeature {
  @Attribute(.unique) var detailedDescription: String
  var creationDate: Date
  
  init(detailedDescription: String) {
    self.detailedDescription = detailedDescription
    self.creationDate = .now
  }
}
