//
//  SyncUpsPlusApp.swift
//  SyncUpsPlus
//
//  Created by Sasha Jaroshevskii on 9/17/25.
//

import ComposableArchitecture
import SwiftUI

@main
struct SyncUpsPlusApp: App {
  // NB: This is static to avoid interference with Xcode previews, which create this entry
  //     point each time they are run.
  @MainActor
  static let store = Store(initialState: AppFeature.State()) {
    AppFeature()
  }
  
  var body: some Scene {
    WindowGroup {
      if isTesting {
        // NB: Don't run application in tests to avoid interference between the app and the test.
        EmptyView()
      } else {
        AppView(store: Self.store)
      }
    }
  }
}
