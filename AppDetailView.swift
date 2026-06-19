//
// AppDetailView.swift
// Comment Comment: Comment Comment Comment SignComment CommentInstall Comment
//

import SwiftUI

struct AppDetailView: View {
 let app: AppPackage
 @EnvironmentObject var appState: AppState
 @State private var showFiles = false
 @State private var showSign = false

 var body: some View {
 ZStack {
 Theme.backgroundGradient.ignoresSafeArea()
 ScrollView {
 VStack(spacing: 20) {
 // Comment Comment
 VStack(spacing: 12) {
 AppIconView(fileName: app.iconFileName)
 .scaleEffect(1.6).frame(height: 90)
 Text(app.displayName).font(.title2.bold()).foregroundColor(Theme.textPrimary)
 Text(app.bundleId).font(.caption).foregroundColor(Theme.textSecondary)
 Text("Version \(app.version) \(app.fileSizeReadable)")
 .font(.caption).foregroundColor(Theme.textSecondary)
 }
 .frame(maxWidth: .infinity).padding(.vertical, 24).glassCard()

 // Comment Comment
 VStack(spacing: 12) {
 OptionButton(icon: "folder.fill", title: "Info Info Info", color: Theme.accent) {
 showFiles = true
 }
 OptionButton(icon: "signature", title: "Sign", color: .orange) {
 showSign = true
 }
 }
 }
 .padding()
 }
 }
 .navigationTitle("Info Info")
 .navigationBarTitleDisplayMode(.inline)
 .sheet(isPresented: $showFiles) {
 AppContentsView(app: app)
 }
 .navigationDestination(isPresented: $showSign) {
 SignOptionsView(app: app)
 }
 }
}

struct OptionButton: View {
 let icon: String; let title: String; let color: Color; let action: () -> Void
 var body: some View {
 Button(action: action) {
 HStack(spacing: 14) {
 Image(systemName: icon).foregroundColor(color).frame(width: 28)
 Text(title).foregroundColor(Theme.textPrimary)
 Spacer()
 Image(systemName: "chevron.left").foregroundColor(Theme.textSecondary).font(.caption)
 }
 .padding().glassCard()
 }
 }
}

/// Comment Comment Comment Comment
struct AppContentsView: View {
 let app: AppPackage
 @State private var items: [FileItem] = []
 var body: some View {
 NavigationStack {
 ZStack {
 Theme.backgroundGradient.ignoresSafeArea()
 List(items) { item in
 FileRow(item: item).listRowBackground(Theme.surface)
 }
 .scrollContentBackground(.hidden)
 }
 .navigationTitle("Info \(app.displayName)")
 .onAppear {
 let url = StorageManager.shared.ipaURL.appendingPathComponent(app.ipaFileName)
 items = IPAInspector.shared.listContents(ipaURL: url)
 }
 }
 }
}
