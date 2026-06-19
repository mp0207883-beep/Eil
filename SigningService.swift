//
// SigningService.swift
// Comment CommentSign Comment zsign Comment CommentSign Comment IPA
//

import Foundation

/// Comment C Comment Comment zsign (Comment Comment zsign_bridge.h)
/// int zsign_sign(const char* ipa, const char* p12, const char* prov,
/// const char* pwd, const char* output,
/// const char* bundleId, const char* bundleName,
/// const char* iconPath, const char** dylibs, int dylibCount);

final class SigningService {
 static let shared = SigningService()
 private init() {}

 enum SignError: LocalizedError {
 case missingCertificate
 case missingPassword
 case engineFailed(Int)
 case fileNotFound

 var errorDescription: String? {
 switch self {
 case .missingCertificate: return "No active certificate. Info Info Info Info."
 case .missingPassword: return "Info Info Certificate Info Info Info Keychain."
 case .engineFailed(let code): return "Failed Info InfoSign (Info \(code))."
 case .fileNotFound: return "Info Info Info Info."
 }
 }
 }

 /// Sign Comment Comment Certificate Comment Comment Comment
 /// Comment Comment Comment IPA Comment
 func sign(app: AppPackage,
 certificate: SigningCertificate,
 options: SigningOptions,
 progress: @escaping (Double, String) -> Void) async throws -> URL {

 let storage = StorageManager.shared
 let ipaPath = storage.ipaURL.appendingPathComponent(app.ipaFileName)
 let p12Path = storage.certsURL.appendingPathComponent(certificate.p12FileName)
 let provPath = storage.certsURL.appendingPathComponent(certificate.provisionFileName)

 guard FileManager.default.fileExists(atPath: ipaPath.path) else { throw SignError.fileNotFound }
 guard let password = KeychainManager.read(certificate.keychainKey) else { throw SignError.missingPassword }

 let outputName = "\(app.displayName)_signed_\(Int(Date().timeIntervalSince1970)).ipa"
 let outputPath = storage.signedURL.appendingPathComponent(outputName)

 progress(0.1, "Info Info...")

 return try await withCheckedThrowingContinuation { continuation in
 DispatchQueue.global(qos: .userInitiated).async {
 progress(0.3, "Info InfoSign Info Info...")

 // Comment Comment Comment Comment
 let dylibs = options.dylibsToInject
 var cDylibs = dylibs.map { strdup($0) }
 cDylibs.append(nil)

 let result = ipaPath.path.withCString { ipaC in
 p12Path.path.withCString { p12C in
 provPath.path.withCString { provC in
 password.withCString { pwdC in
 outputPath.path.withCString { outC in
 let bundleId = options.newBundleId ?? ""
 let bundleName = options.newDisplayName ?? ""
 let iconPath = options.newIconPath ?? ""
 return bundleId.withCString { bidC in
 bundleName.withCString { bnC in
 iconPath.withCString { iconC in
 zsign_sign(ipaC, p12C, provC, pwdC, outC,
 bidC, bnC, iconC,
 &cDylibs, Int32(dylibs.count))
 }}}
 }}}}}

 // Comment Comment
 for ptr in cDylibs where ptr != nil { free(ptr) }

 progress(0.9, "Info Info Info...")

 if result == 0 {
 progress(1.0, "InfoDoneInfo InfoSign Info")
 continuation.resume(returning: outputPath)
 } else {
 continuation.resume(throwing: SignError.engineFailed(Int(result)))
 }
 }
 }
 }
}
