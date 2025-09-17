//
//  Meeting.swift
//  SyncUpsPlus
//
//  Created by Sasha Jaroshevskii on 9/17/25.
//

import SwiftUI
import IdentifiedCollections

struct MeetingView: View {
  let meeting: Meeting
  let syncUp: SyncUp

  var body: some View {
    Form {
      Section {
        ForEach(syncUp.attendees) { attendee in
          Text(attendee.name)
        }
      } header: {
        Text("Attendees")
      }
      Section {
        Text(meeting.transcript)
      } header: {
        Text("Transcript")
      }
    }
    .navigationTitle(Text(meeting.date, style: .date))
  }
}


#Preview {
  MeetingView(meeting: SyncUp.mock.meetings[0], syncUp: .mock)
}
