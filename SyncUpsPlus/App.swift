//
//  App.swift
//  SyncUpsPlus
//
//  Created by Sasha Jaroshevskii on 9/17/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
  @Reducer
  enum Path {
    case detail(SyncUpDetail)
  }
  
  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
    var syncUpsList = SyncUpsList.State()
  }
  
  enum Action {
    case path(StackActionOf<Path>)
    case syncUpsList(SyncUpsList.Action)
  }
  
  var body: some ReducerOf<Self> {
    Scope(state: \.syncUpsList, action: \.syncUpsList) {
      SyncUpsList()
    }
    Reduce { state, action in
      switch action {
      case .path:
        return .none
        
      case .syncUpsList:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

extension AppFeature.Path.State: Equatable {}

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

