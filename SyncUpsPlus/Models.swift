//
//  Models.swift
//  SyncUpsPlus
//
//  Created by Sasha Jaroshevskii on 8/27/25.
//

import Foundation
import IdentifiedCollections
import SwiftUI

struct SyncUp: Equatable, Identifiable, Codable {
  let id: UUID
  var attendees: IdentifiedArrayOf<Attendee> = []
  var duration: Duration = .seconds(60 * 5)
  var meetings: IdentifiedArrayOf<Meeting> = []
  var theme: Theme = .bubblegum
  var title = ""

  var durationPerAttendee: Duration {
    duration / attendees.count
  }
}

struct Attendee: Equatable, Identifiable, Codable {
  let id: UUID
  var name = ""
}

struct Meeting: Equatable, Identifiable, Codable {
  let id: UUID
  let date: Date
  var transcript: String
}

enum Theme: String, CaseIterable, Equatable, Identifiable, Codable {
  var id: Self { self }

  case bubblegum
  case buttercup
  case indigo
  case lavender
  case magenta
  case navy
  case orange
  case oxblood
  case periwinkle
  case poppy
  case purple
  case seafoam
  case sky
  case tan
  case teal
  case yellow

  var accentColor: Color {
    switch self {
    case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .poppy, .seafoam, .sky, .tan, .teal, .yellow:
      .black
    case .indigo, .magenta, .navy, .oxblood, .purple:
      .white
    }
  }

  var mainColor: Color { Color(rawValue) }

  var name: String { rawValue.capitalized }
}

extension SyncUp {
  static let mock = Self(
    id: SyncUp.ID(),
    attendees: [
      Attendee(id: Attendee.ID(), name: "Blob"),
      Attendee(id: Attendee.ID(), name: "Blob Jr"),
      Attendee(id: Attendee.ID(), name: "Blob Sr"),
      Attendee(id: Attendee.ID(), name: "Blob Esq"),
      Attendee(id: Attendee.ID(), name: "Blob III"),
      Attendee(id: Attendee.ID(), name: "Blob I"),
    ],
    meetings: [
      Meeting(
        id: Meeting.ID(),
        date: Date().addingTimeInterval(-60 * 60 * 24 * 7),
        transcript: """
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor \
          incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud \
          exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure \
          dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. \
          Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt \
          mollit anim id est laborum.
          """
      )
    ],
    theme: .orange,
    title: "Design"
  )
}
