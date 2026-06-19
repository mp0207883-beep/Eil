//
// IPAInspector.swift
// Comment Comment Comment (Comment VersionComment Comment Comment) Comment Comment IPA
//

import Foundation
import UIKit
import ZIPFoundation

struct IPAMetadata {
 var displayName: String
 var bundleId: String
 var version: String
 var iconData: Data?
}

final class IPAInspector {
 static let shared = IPAInspector()
 private init() {}

 /// Comment Comment Comment IPA Comment Comment Comment (Comment Payload/*.app/Info.plist Comment)
 func readMetadata(ipaURL: URL) -> IPAMetadata? {
 let tmp = StorageManager.shared.workURL.appendingPathComponent(UUID().uuidString)
 defer { try? FileManager.default.removeItem(at: tmp) }
 do {
 try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)
 try FileManager.default.unzipItem(at: ipaURL, to: tmp)

 let payload = tmp.appendingPathComponent("Payload")
 guard let appName = try FileManager.default.contentsOfDirectory(atPath: payload.path)
 .first(where: { $0.hasSuffix(".app") }) else { return nil }
 let appDir = payload.appendingPathComponent(appName)
 let plistURL = appDir.appendingPathComponent("Info.plist")

 guard let plistData = try? Data(contentsOf: plistURL),
 let plist = try? PropertyListSerialization.propertyList(from: plistData, format: nil) as? [String: Any]
 else { return nil }

 let displayName = (plist["CFBundleDisplayName"] as? String)
 ?? (plist["CFBundleName"] as? String) ?? "Info"
 let bundleId = plist["CFBundleIdentifier"] as? String ?? "unknown.bundle"
 let version = plist["CFBundleShortVersionString"] as? String ?? "1.0"

 // Comment Comment
 var iconData: Data?
 if let icons = plist["CFBundleIcons"] as? [String: Any],
 let primary = icons["CFBundlePrimaryIcon"] as? [String: Any],
 let files = primary["CFBundleIconFiles"] as? [String],
 let iconName = files.last {
 let candidates = try? FileManager.default.contentsOfDirectory(atPath: appDir.path)
 .filter { $0.hasPrefix(iconName) }
 if let best = candidates?.sorted().last {
 iconData = try? Data(contentsOf: appDir.appendingPathComponent(best))
 }
 }

 return IPAMetadata(displayName: displayName, bundleId: bundleId, version: version, iconData: iconData)
 } catch {
 return nil
 }
 }

 /// Comment Files Comment Comment IPA (Comment "Comment Comment Comment")
 func listContents(ipaURL: URL) -> [FileItem] {
 let tmp = StorageManager.shared.workURL.appendingPathComponent(UUID().uuidString)
 do {
 try FileManager.default.createDirectory(at: tmp, withIntermediateDirectories: true)
 try FileManager.default.unzipItem(at: ipaURL, to: tmp)
 return FileBrowser.shared.list(at: tmp)
 } catch {
 return []
 }
 }
}
