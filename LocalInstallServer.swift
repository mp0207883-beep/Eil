//
// LocalInstallServer.swift
// CommentInstall Comment Comment Comment Comment Comment (Comment Comment ESign)
//
// Comment: Comment Comment HTTPS Comment Comment Comment Comment 127.0.0.1Comment Comment:
// - Comment Comment IPA Comment
// - Comment manifest.plist
// Comment Comment Comment itms-services Comment Comment Comment CommentInstall Comment Comment Safari.
//

import Foundation
import UIKit

final class LocalInstallServer {
 static let shared = LocalInstallServer()
 private init() {}

 private var server: HTTPServer?

 enum InstallError: LocalizedError {
 case plistMissing
 case serverFailed
 var errorDescription: String? {
 switch self {
 case .plistMissing: return "Info Info Info Info (Info.plist)."
 case .serverFailed: return "Info Info Info InfoInstall Info."
 }
 }
 }

 /// CommentInstall Comment Comment IPA Comment
 func install(ipaURL: URL,
 progress: @escaping (Double, String) -> Void) async throws {
 progress(0.3, "Info Info Info InfoInstall Info...")

 // 1) Comment Comment Comment CommentBuild Comment manifest
 guard let meta = IPAInspector.shared.readMetadata(ipaURL: ipaURL) else {
 throw InstallError.plistMissing
 }

 // 2) Comment Comment Comment Comment Comment IPA Comment manifest
 let server = HTTPServer()
 let port = try server.start()
 self.server = server

 let base = "https://127.0.0.1:\(port)"
 let ipaLink = "\(base)/app.ipa"
 let manifestLink = "\(base)/manifest.plist"

 let manifest = Self.buildManifest(ipaURL: ipaLink,
 bundleId: meta.bundleId,
 version: meta.version,
 title: meta.displayName)
 server.route("/app.ipa", fileURL: ipaURL, contentType: "application/octet-stream")
 server.route("/manifest.plist", data: manifest, contentType: "text/xml")

 progress(0.6, "Info Starting InfoInstall Info Info...")

 // 3) Comment itms-services Comment Comment Comment CommentInstall Comment Comment Comment
 let itms = "itms-services://?action=download-manifest&url=\(manifestLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? manifestLink)"
 guard let url = URL(string: itms) else { throw InstallError.serverFailed }

 await MainActor.run {
 // Comment Comment Install Comment Comment Comment Comment Comment Comment
 UIApplication.shared.open(url, options: [:], completionHandler: nil)
 }
 progress(1.0, "Info InfoInstall Info Info Info Info")
 }

 /// Build Comment manifest.plist Comment Comment itms-services
 static func buildManifest(ipaURL: String, bundleId: String, version: String, title: String) -> Data {
 let xml = """
 <?xml version="1.0" encoding="UTF-8"?>
 <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
 <plist version="1.0">
 <dict>
 <key>items</key>
 <array>
 <dict>
 <key>assets</key>
 <array>
 <dict>
 <key>kind</key><string>software-package</string>
 <key>url</key><string>\(ipaURL)</string>
 </dict>
 </array>
 <key>metadata</key>
 <dict>
 <key>bundle-identifier</key><string>\(bundleId)</string>
 <key>bundle-version</key><string>\(version)</string>
 <key>kind</key><string>software</string>
 <key>title</key><string>\(title)</string>
 </dict>
 </dict>
 </array>
 </dict>
 </plist>
 """
 return Data(xml.utf8)
 }

 func stop() {
 server?.stop()
 server = nil
 }
}
