//
// RootTabView.swift
// Main Interface: Three tabs (FilesComment AppsComment Settings)
//

import SwiftUI

struct RootTabView: View {
 @State private var selection = 1

 var body: some View {
 ZStack {
 Theme.backgroundGradient.ignoresSafeArea()

 TabView(selection: $selection) {
 FilesView()
 .tabItem { Label("Files", systemImage: "folder.fill") }
 .tag(0)

 AppLibraryView()
 .tabItem { Label("Apps", systemImage: "square.grid.2x2.fill") }
 .tag(1)

 SettingsView()
 .tabItem { Label("Settings", systemImage: "gearshape.fill") }
 .tag(2)
 }
 .tint(Theme.accent)
 }
 .environment(\.layoutDirection, .leftToRight) // English LTR support
 }
}
