//
// CertificateChecker.swift
// Comment Comment Certificate (Comment / Comment / Comment) Comment zsign + OCSP
//

import Foundation

/// Comment C Comment zsign:
/// int zsign_check_cert(const char* p12, const char* pwd, char* outStatus, int outLen);
/// Comment: 0 Comment 1 Comment 2 Comment -1 Comment

final class CertificateChecker {
 static let shared = CertificateChecker()
 private init() {}

 func check(certificate: SigningCertificate) async -> CertificateStatus {
 let storage = StorageManager.shared
 let p12Path = storage.certsURL.appendingPathComponent(certificate.p12FileName)
 guard FileManager.default.fileExists(atPath: p12Path.path),
 let password = KeychainManager.read(certificate.keychainKey) else {
 return .unknown
 }

 return await withCheckedContinuation { continuation in
 DispatchQueue.global(qos: .userInitiated).async {
 var buffer = [CChar](repeating: 0, count: 512)
 let code = p12Path.path.withCString { p12C in
 password.withCString { pwdC in
 zsign_check_cert(p12C, pwdC, &buffer, 512)
 }
 }
 let status: CertificateStatus
 switch code {
 case 0: status = .valid
 case 1: status = .revoked
 case 2: status = .expired
 default: status = .unknown
 }
 continuation.resume(returning: status)
 }
 }
 }
}
