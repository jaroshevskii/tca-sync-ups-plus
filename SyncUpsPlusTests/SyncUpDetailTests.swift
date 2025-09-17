//
//  SyncUpDetailTests.swift
//  SyncUpsPlusTests
//
//  Created by Sasha Jaroshevskii on 9/17/25.
//

import ComposableArchitecture
import Foundation
import Testing

@testable import SyncUpsPlus

@MainActor
struct SyncUpDetailTests {
  @Test
  func editNonExhaustivity() async {
    let syncUp = SyncUp(
      id: SyncUp.ID(),
      title: "Point-Free Morning Sync"
    )
    let store = TestStore(
      initialState: SyncUpDetail.State(syncUp: Shared(value: syncUp))
    ) {
      SyncUpDetail()
    }
    store.exhaustivity = .off(showSkippedAssertions: true)
    
    await store.send(.editButtonTapped)
    
    var editedSyncUp = syncUp
    editedSyncUp.title = "Point-Free Evening Sync"
    
    await store.send(\.destination.edit.binding.syncUp, editedSyncUp)
    
    await store.send(.doneEditingButtonTapped) {
      $0.$syncUp.withLock { $0 = editedSyncUp }
    }
  }
  
  @Test
  func edit() async {
    let syncUp = SyncUp(
      id: SyncUp.ID(),
      title: "Point-Free Morning Sync"
    )
    let store = TestStore(
      initialState: SyncUpDetail.State(syncUp: Shared(value: syncUp))
    ) {
      SyncUpDetail()
    }
    
    await store.send(.editButtonTapped) {
      $0.destination = .edit(SyncUpForm.State(syncUp: syncUp))
    }
    
    var editedSyncUp = syncUp
    editedSyncUp.title = "Point-Free Evening Sync"
    
    await store.send(\.destination.edit.binding.syncUp, editedSyncUp) {
      $0.destination?.modify(\.edit) { $0.syncUp = editedSyncUp }
    }
    
    await store.send(.doneEditingButtonTapped) {
      $0.destination = nil
      $0.$syncUp.withLock { $0 = editedSyncUp }
    }
  }
}
