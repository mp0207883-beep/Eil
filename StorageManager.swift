//
// StorageManager.swift
// Comment Comment Comment Comment CommentApps Comment
//

import Foundation

final class StorageManager {
 static let shared = StorageManager()
 private init() {}

 private let fm = FileManager.default

 // Comment Comment Comment Documents
 var documentsURL: URL {
 fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
 }
 var ipaURL: URL { documentsURL.appendingPathComponent("IPAs", isDirectory: true) }
 var certsURL: URL { documentsURL.appendingPathComponent("Certificates", isDirectory: true) }
 var iconsURL: URL { documentsURL.appendingPathComponent("Icons", isDirectory: true) }
 var workURL: URL { documentsURL.appendingPathComponent("Work", isDirectory: true) }
 var signedURL: URL { documentsURL.appendingPathComponent("Signed", isDirectory: true) }

 private var appsDB: URL { documentsURL.appendingPathComponent("apps.json") }
 private var certsDB: URL { documentsURL.appendingPathComponent("certs.json") }

 /// Comment Comment Comment Starting Comment
 func bootstrap() {
 for url in [ipaURL, certsURL, iconsURL, workURL, signedURL] {
 try? fm.createDirectory(at: url, withIntermediateDirectories: true)
 }
 }

 // MARK: - Apps
 func loadApps() -> [AppPackage] {
 guard let data = try? Data(contentsOf: appsDB),
 let apps = try? JSONDecoder().decode([AppPackage].self, from: data) else { return [] }
 return apps.sorted { $0.importedAt > $1.importedAt }
 }

 func saveApps(_ apps: [AppPackage]) {
 if let data = try? JSONEncoder().encode(apps) {
 try? data.write(to: appsDB)
 }
 }

 func addApp(_ app: AppPackage) {
 var apps = loadApps()
 apps.append(app)
 saveApps(apps)
 }

 func deleteApp(_ app: AppPackage) {
 var apps = loadApps()
 apps.removeAll { $0.id == app.id }
 saveApps(apps)
 try? fm.removeItem(at: ipaURL.appendingPathComponent(app.ipaFileName))
 if let icon = app.iconFileName {
 try? fm.removeItem(at: iconsURL.appendingPathComponent(icon))
 }
 }

 // MARK: - Comment
 func loadCertificates() -> [SigningCertificate] {
 guard let data = try? Data(contentsOf: certsDB),
 let certs = try? JSONDecoder().decode([SigningCertificate].self, from: data) else { return [] }
 return certs
 }

 func saveCertificates(_ certs: [SigningCertificate]) {
 if let data = try? JSONEncoder().encode(certs) {
 try? data.write(to: certsDB)
 }
 }

 func addCertificate(_ cert: SigningCertificate) {
 var certs = loadCertificates()
 certs.append(cert)
 saveCertificates(certs)
 }
}
