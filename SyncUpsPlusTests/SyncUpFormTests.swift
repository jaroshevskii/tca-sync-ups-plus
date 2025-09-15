//
//  SyncUpFormTests.swift
//  SyncUpsPlusTests
//
//  Created by Sasha Jaroshevskii on 9/8/25.
//

import ComposableArchitecture
import Testing
import Foundation

@testable import SyncUpsPlus

@MainActor
struct SyncUpFormTests {
  @Test
  func addAttendee() async {
    let store = TestStore(
      initialState: SyncUpForm.State(
        syncUp: SyncUp(id: SyncUp.ID())
      )
    ) {
      SyncUpForm()
    } withDependencies: {
      $0.uuid = .incrementing
    }
    
    await store.send(.addAttendeeButtonTapped) {
      $0.focus = .attendee(Attendee.ID(0))
      $0.syncUp.attendees.append(Attendee(id: Attendee.ID(0)))
    }
  }
  
  @Test
  func removeFocusedAttendee() async {
    let attendee1 = Attendee(id: Attendee.ID())
    let attendee2 = Attendee(id: Attendee.ID())
    let store = TestStore(
      initialState: SyncUpForm.State(
        focus: .attendee(attendee1.id),
        syncUp: SyncUp(
          id: SyncUp.ID(),
          attendees: [attendee1, attendee2]
        )
      )
    ) {
      SyncUpForm()
    }

    await store.send(.onDeleteAttendees([0])) {
      $0.focus = .attendee(attendee2.id)
      $0.syncUp.attendees = [attendee2]
    }
  }

  @Test
  func removeAttendee() async {
    let store = TestStore(
      initialState: SyncUpForm.State(
        syncUp: SyncUp(
          id: SyncUp.ID(),
          attendees: [
            Attendee(id: Attendee.ID(0)),
            Attendee(id: Attendee.ID(1))
          ]
        )
      )
    ) {
      SyncUpForm()
    }
    store.exhaustivity = .off
    
    await store.send(.onDeleteAttendees([0])) {
      $0.syncUp.attendees = [
        Attendee(id: Attendee.ID(1))
      ]
    }
  }
}
