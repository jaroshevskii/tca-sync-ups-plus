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
  @MainActor
  static let store = Store(initialState: AppFeature.State()) {
    AppFeature()
  }
  
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        AppView(store: Self.store)
      }
    }
  }
}
