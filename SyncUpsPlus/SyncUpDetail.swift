//
//  SyncUpDetail.swift
//  SyncUpsPlus
//
//  Created by Sasha Jaroshevskii on 9/16/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct SyncUpDetail {
  @ObservableState
  struct State: Equatable {
    @Presents var editSyncUp: SyncUpForm.State?
    @Shared var syncUp: SyncUp
  }
  
  enum Action {
    case cancelEditButtonTapped
    case deleteButtonTapped
    case doneEditingButtonTapped
    case editButtonTapped
    case editSyncUp(PresentationAction<SyncUpForm.Action>)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .cancelEditButtonTapped:
        state.editSyncUp = nil
        return .none
        
      case .deleteButtonTapped:
        return .none
        
      case .doneEditingButtonTapped:
        guard let editedSyncUp = state.editSyncUp?.syncUp else {
          return .none
        }
        state.$syncUp.withLock { $0 = editedSyncUp }
        state.editSyncUp = nil
        return .none
        
      case .editButtonTapped:
        state.editSyncUp = SyncUpForm.State(syncUp: state.syncUp)
        return .none
        
      case .editSyncUp:
        return .none
      }
    }
    .ifLet(\.$editSyncUp, action: \.editSyncUp) {
      SyncUpForm()
    }
  }
}

struct SyncUpDetailView: View {
  @Bindable var store: StoreOf<SyncUpDetail>
  
  var body: some View {
    Form {
      Section {
        NavigationLink {
        } label: {
          Label("Start Meeting", systemImage: "timer")
            .font(.headline)
            .foregroundColor(.accentColor)
        }
        HStack {
          Label("Length", systemImage: "clock")
          Spacer()
          Text(store.syncUp.duration.formatted(.units()))
        }

        HStack {
          Label("Theme", systemImage: "paintpalette")
          Spacer()
          Text(store.syncUp.theme.name)
            .padding(4)
            .foregroundColor(store.syncUp.theme.accentColor)
            .background(store.syncUp.theme.mainColor)
            .cornerRadius(4)
        }
      } header: {
        Text("Sync-up Info")
      }

      if !store.syncUp.meetings.isEmpty {
        Section {
          ForEach(store.syncUp.meetings) { meeting in
            Button {
            } label: {
              HStack {
                Image(systemName: "calendar")
                Text(meeting.date, style: .date)
                Text(meeting.date, style: .time)
              }
            }
          }
        } header: {
          Text("Past meetings")
        }
      }

      Section {
        ForEach(store.syncUp.attendees) { attendee in
          Label(attendee.name, systemImage: "person")
        }
      } header: {
        Text("Attendees")
      }

      Section {
        Button("Delete") {
          store.send(.deleteButtonTapped)
        }
        .foregroundColor(.red)
        .frame(maxWidth: .infinity)
      }
    }
    .navigationTitle(Text(store.syncUp.title))
    .toolbar {
      Button("Edit") {
        store.send(.editButtonTapped)
      }
    }
    .sheet(item: $store.scope(state: \.editSyncUp, action: \.editSyncUp)) { editSyncUpStore in
      NavigationStack {
        SyncUpFormView(store: editSyncUpStore)
          .navigationTitle(store.syncUp.title)
          .toolbar {
            ToolbarItem {
              Button("Cancel") {
                store.send(.cancelEditButtonTapped)
              }
            }
            ToolbarItem {
              Button("Done") {
                store.send(.doneEditingButtonTapped)
              }
            }
          }
      }
    }
  }
}

#Preview {
  NavigationStack {
    SyncUpDetailView(
      store: Store(
        initialState: SyncUpDetail.State(
          syncUp: Shared(value: .mock)
        )
      ) {
        SyncUpDetail()
      }
    )
  }
}
