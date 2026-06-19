//
// AppLibraryViewModel.swift
//

import Foundation
import SwiftUI

@MainActor
final class AppLibraryViewModel: ObservableObject {
 @Published var showImporter = false
 @Published var showAlert = false
 @Published var alertTitle = ""
 @Published var alertMessage = ""
 @Published var pendingMeta: IPAMetadata?
 @Published var pendingIPAURL: URL?

 func totalSize(_ apps: [AppPackage]) -> String {
 let total = apps.reduce(Int64(0)) { $0 + $1.fileSizeBytes }
 return ByteCountFormatter.string(fromByteCount: total, countStyle: .file)
 }

 /// Comment Comment IPA Comment Comment Comment Comment Comment
 func importIPA(_ result: Result<[URL], Error>, appState: AppState) {
 guard case let .success(urls) = result, let url = urls.first else { return }
 guard url.startAccessingSecurityScopedResource() else { return }
 defer { url.stopAccessingSecurityScopedResource() }

 // Comment Comment IPA Comment Comment
 let destName = url.lastPathComponent
 let dest = StorageManager.shared.ipaURL.appendingPathComponent(destName)
 try? FileManager.default.removeItem(at: dest)
 try? FileManager.default.copyItem(at: url, to: dest)

 guard let meta = IPAInspector.shared.readMetadata(ipaURL: dest) else {
 alertTitle = "Info"; alertMessage = "Info Info Info Info IPA."; showAlert = true
 return
 }

 pendingMeta = meta
 pendingIPAURL = dest

 // Comment Comment: Comment Comment Comment Comment Comment Bundle ID Comment Comment
 let isOfficialInstalled = appState.importedApps.contains { $0.bundleId == meta.bundleId }
 alertTitle = "Info Info"
 if isOfficialInstalled {
 alertMessage = "Info Info Info Info (\(meta.bundleId)). Info Info Info Info Info AppsInfo Info Info Info Info Bundle ID Info Info."
 } else {
 alertMessage = "Info Info Info Info \"\(meta.displayName)\" Info Info AppsInfo"
 }
 showAlert = true
 }

 func confirmImport(appState: AppState) {
 guard let meta = pendingMeta, let ipaURL = pendingIPAURL else { return }

 // Save Comment
 var iconName: String?
 if let data = meta.iconData {
 iconName = "\(UUID().uuidString).png"
 try? data.write(to: StorageManager.shared.iconsURL.appendingPathComponent(iconName!))
 }

 let size = (try? FileManager.default.attributesOfItem(atPath: ipaURL.path)[.size] as? Int64) ?? 0
 let app = AppPackage(
 displayName: meta.displayName,
 bundleId: meta.bundleId,
 version: meta.version,
 iconFileName: iconName,
 ipaFileName: ipaURL.lastPathComponent,
 fileSizeBytes: size ?? 0
 )
 StorageManager.shared.addApp(app)
 appState.reload()
 pendingMeta = nil; pendingIPAURL = nil
 }
}
