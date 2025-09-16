//
//  SyncUpsPlusApp.swift
//  SyncUpsPlus
//
//  Created by Sasha Jaroshevskii on 8/27/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct SyncUpsPlusApp: App {
  @MainActor
  static let store = Store(initialState: SyncUpsList.State()) {
    SyncUpsList()
  }
  
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        SyncUpsListView(store: Self.store)
      }
    }
  }
}
