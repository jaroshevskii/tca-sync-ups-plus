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

struct AppView: View {
  @Bindable var store: StoreOf<AppFeature>
  
  var body: some View {
    NavigationStack(
      path: $store.scope(state: \.path, action: \.path)
    ) {
      SyncUpsListView(
        store: store.scope(state: \.syncUpsList, action: \.syncUpsList)
      )
    } destination: { store in
      switch store.case {
      case let .detail(detailStore):
        SyncUpDetailView(store: detailStore)
      }
    }
  }
}

#Preview {
  AppView(
    store: Store(
      initialState: AppFeature.State(
        syncUpsList: SyncUpsList.State()
      )
    ) {
      AppFeature()
    }
  )
}

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

