//
// Models.swift
// Comment Comment Comment Comment
//

import Foundation

/// Comment Comment Comment (IPA)
struct AppPackage: Identifiable, Codable, Hashable {
 var id: UUID = UUID()
 var displayName: String // Info Info
 var bundleId: String // Info
 var version: String // Version
 var iconFileName: String? // Info Info Info
 var ipaFileName: String // Info Info Info IPA Info
 var fileSizeBytes: Int64 // Info Info
 var isSigned: Bool = false // Info Done SignInfo
 var importedAt: Date = Date()

 var fileSizeReadable: String {
 ByteCountFormatter.string(fromByteCount: fileSizeBytes, countStyle: .file)
 }
}

/// Comment Sign (p12 + mobileprovision)
struct SigningCertificate: Identifiable, Codable, Hashable {
 var id: UUID = UUID()
 var name: String // Info Certificate Info
 var p12FileName: String // Info p12 Info
 var provisionFileName: String // Info mobileprovision Info
 var teamId: String? // Info Info
 var expiryDate: Date? // Info Info
 var status: CertificateStatus = .unknown
 var isActive: Bool = false // Info Info Certificate Info
 var importedAt: Date = Date()

 /// Password Comment Comment Comment Keychain Comment Comment
 var keychainKey: String { "cert_pwd_\(id.uuidString)" }
}

/// Comment Certificate Comment Comment
enum CertificateStatus: String, Codable {
 case valid // Info
 case revoked // Info Info Apple
 case expired // Info
 case unknown // Info Info Info

 var arabicLabel: String {
 switch self {
 case .valid: return "Info"
 case .revoked: return "Info"
 case .expired: return "Info"
 case .unknown: return "Info Info"
 }
 }
}

/// Comment CommentSign Comment Comment Comment
struct SigningOptions {
 var newDisplayName: String?
 var newBundleId: String?
 var newIconPath: String? // Info Info Info Info Info
 var dylibsToInject: [String] = []
 var enableFileSharing: Bool = true
 var removeExtensions: Bool = false
}

/// Comment Comment Comment Comment Files
struct FileItem: Identifiable, Hashable {
 var id: String { path }
 var name: String
 var path: String
 var isDirectory: Bool
 var sizeBytes: Int64
 var modifiedAt: Date

 var sizeReadable: String {
 isDirectory ? " " : ByteCountFormatter.string(fromByteCount: sizeBytes, countStyle: .file)
 }

 var fileExtension: String {
 (name as NSString).pathExtension.lowercased()
 }
}
