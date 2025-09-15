//
//  SyncUpsListTest.swift
//  SyncUpsPlusTests
//
//  Created by Sasha Jaroshevskii on 9/4/25.
//

import ComposableArchitecture
import Testing
import Foundation

@testable import SyncUpsPlus

@MainActor
struct SyncUpsListTest {
  @Test
  func addSyncUpNonExhaustive() async {
    let store = TestStore(initialState: SyncUpsList.State()) {
      SyncUpsList()
    } withDependencies: {
      $0.uuid = .incrementing
    }
    store.exhaustivity = .off(showSkippedAssertions: true)
    
    await store.send(.addSyncUpButtonTapped)
    
    let editedSyncUp = SyncUp(
      id: SyncUp.ID(0),
      attendees: [
        Attendee(id: Attendee.ID(), name: "Blob"),
        Attendee(id: Attendee.ID(), name: "Blob Jr."),
      ],
      title: "Point-Free morning sync"
    )
    await store.send(\.addSyncUp.binding.syncUp, editedSyncUp)
    
    await store.send(.confirmAddButtonTapped) {
      $0.syncUps = [editedSyncUp]
    }
  }
  
  @Test
  func addSyncUp() async {
    let store = TestStore(initialState: SyncUpsList.State()) {
      SyncUpsList()
    } withDependencies: {
      $0.uuid = .incrementing
    }
                          
    await store.send(.addSyncUpButtonTapped) {
      $0.addSyncUp = SyncUpForm.State(
        syncUp: SyncUp(id: SyncUp.ID(0))
      )
    }
    
    let editedSyncUp = SyncUp(
      id: SyncUp.ID(0),
      attendees: [
        Attendee(id: Attendee.ID(), name: "Blob"),
        Attendee(id: Attendee.ID(), name: "Blob Jr."),
      ],
      title: "Point-Free morning sync"
    )
    await store.send(\.addSyncUp.binding.syncUp, editedSyncUp) {
      $0.addSyncUp?.syncUp = editedSyncUp
    }
    
    await store.send(.confirmAddButtonTapped) {
      $0.addSyncUp = nil
      $0.syncUps = [editedSyncUp]
    }
  }
  
  @Test
  func deletion() async {
    let store = TestStore(
      initialState: SyncUpsList.State(
        syncUps: [
          SyncUp(
            id: SyncUp.ID(),
            title: "Morning Sync"
          )
        ]
      )
    ) {
      SyncUpsList()
    }
    
    await store.send(.onDelete([0])) {
      $0.syncUps = []
    }
  }
}
