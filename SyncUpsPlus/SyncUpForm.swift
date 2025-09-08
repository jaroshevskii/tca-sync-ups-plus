//
//  SyncUpForm.swift
//  SyncUpsPlus
//
//  Created by Sasha Jaroshevskii on 9/5/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct SyncUpForm {
  @ObservableState
  struct State: Equatable {
    var focus: Field? = .title
    var syncUp: SyncUp

    enum Field: Hashable {
      case attendee(Attendee.ID)
      case title
    }
  }

  enum Action: BindableAction {
    case addAttendeeButtonTapped
    case binding(BindingAction<State>)
    case onDeleteAttendees(IndexSet)
  }

  var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .addAttendeeButtonTapped:
        let attendee = Attendee(id: Attendee.ID())
        state.syncUp.attendees.append(attendee)
        state.focus = .attendee(attendee.id)
        return .none
        
      case .binding:
        return .none

      case let .onDeleteAttendees(indices):
        state.syncUp.attendees.remove(atOffsets: indices)
        guard
          !state.syncUp.attendees.isEmpty,
          let firstIndex = indices.first
        else {
          state.syncUp.attendees.append(
            Attendee(id: Attendee.ID())
          )
          return .none
        }
        let index = min(firstIndex, state.syncUp.attendees.count - 1)
        state.focus = .attendee(state.syncUp.attendees[index].id)
        return .none
      }
    }
  }
}

struct SyncUpFormView: View {
  @Bindable var store: StoreOf<SyncUpForm>
  @FocusState var focus: SyncUpForm.State.Field?
  
  var body: some View {
    Form {
      Section {
        TextField("Title", text: $store.syncUp.title)
          .focused($focus, equals: .title)
        HStack {
          Slider(value: $store.syncUp.duration.minutes, in: 5...30, step: 1) {
            Text("Length")
          }
          Spacer()
          Text(store.syncUp.duration.formatted(.units()))
        }
        ThemePicker(selection: $store.syncUp.theme)
      } header: {
        Text("Sync-up Info")
      }
      Section {
        ForEach($store.syncUp.attendees) { $attendee in
          TextField("Name", text: $attendee.name)
            .focused($focus, equals: .attendee(attendee.id))
        }
        .onDelete { indices in
          store.send(.onDeleteAttendees(indices))
        }

        Button("New attendee") {
          store.send(.addAttendeeButtonTapped)
        }
      } header: {
        Text("Attendees")
      }
    }
    .bind($store.focus, to: $focus)
  }
}

#Preview {
  SyncUpFormView(
    store: Store(
      initialState: SyncUpForm.State(
        syncUp: .mock
      )
    ) {
      SyncUpForm()
    }
  )
}

struct ThemePicker: View {
  @Binding var selection: Theme

  var body: some View {
    Picker("Theme", selection: $selection) {
      ForEach(Theme.allCases) { theme in
        ZStack {
          RoundedRectangle(cornerRadius: 4)
            .fill(theme.mainColor)
          Label(theme.name, systemImage: "paintpalette")
            .padding(4)
        }
        .foregroundStyle(theme.accentColor)
        .fixedSize(horizontal: false, vertical: true)
        .tag(theme)
      }
    }
  }
}

extension Duration {
  fileprivate var minutes: Double {
    get { Double(components.seconds / 60) }
    set { self = .seconds(newValue * 60) }
  }
}

extension View {
  fileprivate func onFirstAppear(perform action: @escaping () -> Void) -> some View {
    self.modifier(OnFirstAppear(action: action))
  }
  
  private struct OnFirstAppear: ViewModifier {
    let action: () -> Void
    
    @State private var hasAppeared = false
    
    func body(content: Content) -> some View {
      content
        .onAppear {
          guard !hasAppeared else { return }
          hasAppeared = true
          action()
        }
    }
  }
}
