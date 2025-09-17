//
//  AppFeatureTests.swift
//  SyncUpsPlusTests
//
//  Created by Sasha Jaroshevskii on 9/17/25.
//

import ComposableArchitecture
import Testing

@testable import SyncUpsPlus

@MainActor
struct AppFeatureTests {
  // TODO: Recheck how it works
  @Test
  func delete() async throws {
    let syncUp = SyncUp.mock
    @Shared(.syncUps) var syncUps = [syncUp]
    
    let store = TestStore(initialState: AppFeature.State()) {
      AppFeature()
    }
    
    let sharedSyncUp = try #require(Shared($syncUps[id: syncUp.id]))
    
    await store.send(\.path.push, (id: 0, .detail(SyncUpDetail.State(syncUp: sharedSyncUp)))) {
      $0.path[id: 0] = .detail(SyncUpDetail.State(syncUp: sharedSyncUp))
    }
    
    await store.send(\.path[id: 0].detail.deleteButtonTapped) {
      $0.path[id: 0, case: \.detail]?.destination = .alert(.deleteSyncUp)
    }
    
    await store.send(\.path[id: 0].detail.destination.alert.confirmButtonTapped) {
      $0.path[id: 0, case: \.detail]?.destination = nil
      $0.syncUpsList.$syncUps.withLock { $0 = [] }
    }
    
    await store.receive(\.path.popFrom) {
      $0.path = StackState()
    }
  }
}
