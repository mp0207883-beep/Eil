//
// InstallService.swift
// CommentInstall Comment Comment Comment Comment (Comment Comment Comment Comment)
//
// CommentDoneComment Comment Comment:
// 1) Comment Comment Comment: Comment Comment Comment (installer / AppSync) Comment Process.
// Comment Comment Comment Comment Comment Comment Comment Comment Comment Comment Safari.
// 2) Comment itms-services Comment Comment Comment HTTPS Comment Comment.
//

import Foundation
import UIKit

final class InstallService {
 static let shared = InstallService()
 private init() {}

 enum InstallError: LocalizedError {
 case extractionFailed
 case installerFailed(String)
 case notJailbroken

 var errorDescription: String? {
 switch self {
 case .extractionFailed: return "Failed Info Info Info IPA."
 case .installerFailed(let msg): return "Failed InfoInstall: \(msg)"
 case .notJailbroken: return "Info Info Info Info Info."
 }
 }
 }

 /// CommentInstall Comment Comment Comment Comment Comment Comment
 /// Comment Comment Comment Comment Comment Comment CommentInstall Comment IPA Comment.
 func installDirectly(ipaURL: URL,
 progress: @escaping (Double, String) -> Void) async throws {
 progress(0.2, "Info Info Info Info Info...")

 guard JailbreakHelper.isJailbroken else {
 throw InstallError.notJailbroken
 }

 progress(0.5, "Info InfoInstall Info Info...")

 // Comment Comment Comment: Comment Comment CommentInstall Comment.
 // appinst / installipa Comment Comment Comment Comment AppSync Unified.
 let candidates = ["/usr/bin/appinst", "/usr/bin/installipa", "/usr/local/bin/appinst"]
 guard let tool = candidates.first(where: { FileManager.default.fileExists(atPath: $0) }) else {
 // Comment Comment Comment Comment (Comment Comment + itms-services)
 try await LocalInstallServer.shared.install(ipaURL: ipaURL, progress: progress)
 return
 }

 let result = try JailbreakHelper.run(tool: tool, args: [ipaURL.path])
 if result.exitCode != 0 {
 throw InstallError.installerFailed(result.output)
 }
 progress(1.0, "Done InfoInstall Info")
 }
}

/// Comment Comment Comment Comment Comment
enum JailbreakHelper {
 /// Comment Comment
 static var isJailbroken: Bool {
 #if targetEnvironment(simulator)
 return false
 #else
 let paths = ["/Applications/Cydia.app", "/usr/sbin/sshd",
 "/bin/bash", "/usr/bin/appinst", "/var/jb"]
 return paths.contains { FileManager.default.fileExists(atPath: $0) }
 #endif
 }

 struct ProcessResult { let exitCode: Int32; let output: String }

 /// Comment Comment Comment (Comment Comment Comment Comment Comment Comment Comment)
 static func run(tool: String, args: [String]) throws -> ProcessResult {
 let task = Process()
 task.executableURL = URL(fileURLWithPath: tool)
 task.arguments = args
 let pipe = Pipe()
 task.standardOutput = pipe
 task.standardError = pipe
 try task.run()
 task.waitUntilExit()
 let data = pipe.fileHandleForReading.readDataToEndOfFile()
 let output = String(data: data, encoding: .utf8) ?? ""
 return ProcessResult(exitCode: task.terminationStatus, output: output)
 }
}
