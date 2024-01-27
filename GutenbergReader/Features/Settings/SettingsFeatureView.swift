//
//  SettingsFeatureView.swift
//  GutenbergReader
//
//  Created by Fikret Onur ÖZDİL on 21.01.2024.
//

import SwiftUI
import ComposableArchitecture
import StoreKit

struct SettingsFeatureView: View {
    let store: Store<SettingsFeature.State, SettingsFeature.Action>
    @Environment(\.requestReview) var requestReview
    var body: some View {
        WithViewStore(self.store) { $0 } content: { viewStore in
            Form {
                Section("Appearance") {
                    Picker(selection: viewStore.binding(get: \.themeMode, send: { value in
                            .toggleThemeModeTapped(value)
                    })) {
                        Text("System")
                            .tag(ThemeMode.defaultTheme)
                        Text("Light")
                            .tag(ThemeMode.lightTheme)
                        Text("Dark")
                            .tag(ThemeMode.darkTheme)
                    } label: {
                        Text("Theme")
                    }
                    .pickerStyle(.segmented)
                }

                Section("About") {
                    Button {
                        viewStore.send(.showingAboutInfo(true))
                    } label: {
                        Label {
                            Text("About App")
                        } icon: {
                            Image(systemName: "info.circle")
                        }
                    }
                }

                Section("Review") {
                    Button {
                        requestReview()
                    } label: {
                        Label {
                            Text("Review App")
                        } icon: {
                            Image(systemName: "star")
                        }
                    }
                }

                Section("Links") {
                    Label {
                        Link("Visit Project Github", destination: URL(string: "https://www.hackingwithswift.com/quick-start/swiftui")!)
                    } icon: {
                        Image(systemName: "link")
                    }
                    Label {
                        Link("Visit Project Gutenberg", destination: URL(string: "https://www.gutenberg.org/")!)
                    } icon: {
                        Image(systemName: "link")
                    }
                }
            }
            .sheet(isPresented: viewStore.binding(get: \.showingAboutInfo, send: {.showingAboutInfo($0)}), content: {
                ZStack(alignment: .topTrailing, content: {
                    HStack(content: {
                        Spacer()
                        Button(action: {
                            viewStore.send(.showingAboutInfo(false))
                        }, label: {
                            Image(systemName: "xmark")
                                .font(.title)
                        })
                        .buttonStyle(.plain)
                    })
                    .padding(20)

                    VStack {
                        Spacer()
                        AboutInfoView()
                        Spacer()
                    }
                })
            })
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    let store = Store(initialState: SettingsFeature.State()) {
        SettingsFeature()
    }

    return SettingsFeatureView(store: store)
}
