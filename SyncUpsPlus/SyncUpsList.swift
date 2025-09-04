//
//  SyncUpsList.swift
//  SyncUpsPlus
//
//  Created by Sasha Jaroshevskii on 8/27/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct SyncUpsList {
  @ObservableState
  struct State: Equatable {
    var syncUps: IdentifiedArrayOf<SyncUp> = []
  }
  
  enum Action {
    case addSyncUpButtonTapped
    case onDelete(IndexSet)
    case syncUpTapped(id: SyncUp.ID)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addSyncUpButtonTapped:
        return .none
        
      case let .onDelete(indexSet):
        state.syncUps.remove(atOffsets: indexSet)
        return .none
        
      case .syncUpTapped(id: let id):
        return .none
      }
    }
  }
}

struct SyncUpsListView: View {
  let store: StoreOf<SyncUpsList>
  
  var body: some View {
    List {
      ForEach(store.syncUps) { syncUp in
        Button {
          
        } label: {
          CardView(syncUp: syncUp)
        }
        .listRowBackground(syncUp.theme.mainColor)
      }
      .onDelete { indexSet in
        store.send(.onDelete(indexSet))
      }
    }
    .toolbar {
      Button {
        store.send(.addSyncUpButtonTapped)
      } label: {
        Image(systemName: "plus")
      }
    }
    .navigationTitle("Daily Sync-ups")
  }
}

struct CardView: View {
  let syncUp: SyncUp

  var body: some View {
    VStack(alignment: .leading) {
      Text(syncUp.title)
        .font(.headline)
      Spacer()
      HStack {
        Label("\(syncUp.attendees.count)", systemImage: "person.3")
        Spacer()
        Label(syncUp.duration.formatted(.units()), systemImage: "clock")
          .labelStyle(.trailingIcon)
      }
      .font(.caption)
    }
    .padding()
    .foregroundStyle(syncUp.theme.accentColor)
  }
}

struct TrailingIconLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.title
      configuration.icon
    }
  }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
  static var trailingIcon: Self { Self() }
}

#Preview {
  NavigationStack {
    SyncUpsListView(
      store: Store(
        initialState: SyncUpsList.State(
          syncUps: [.mock]
        )
      ) {
        SyncUpsList()
          ._printChanges()
      }
    )
  }
}
