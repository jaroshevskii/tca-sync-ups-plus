//
//  SyncUpListTest.swift
//  SyncUpsPlusTests
//
//  Created by Sasha Jaroshevskii on 9/4/25.
//

import ComposableArchitecture
import Testing
import Foundation

@testable import SyncUpsPlus

@MainActor
struct SyncUpListTest {
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
