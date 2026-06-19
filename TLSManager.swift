//
// TLSManager.swift
// Comment Comment TLS Comment CommentInstall Comment
//
// Comment Comment: itms-services Comment Comment HTTPS Comment. Comment Comment Comment
// Comment Comment CommentSign Comment Comment Comment Comment Comment Comment Comment CommentDoneComment Comment
// Comment AppSync Comment Comment Comment. Comment Comment Comment TLS Comment Comment.
//

import Foundation
import Network
import Security

enum TLSManager {
 /// Comment TLS Comment Comment Comment (identity) Comment Comment Comment Comment Comment.
 static func serverTLSOptions() -> NWProtocolTLS.Options {
 let options = NWProtocolTLS.Options()
 if let identity = loadIdentity() {
 sec_protocol_options_set_local_identity(
 options.securityProtocolOptions,
 sec_identity_create(identity)!
 )
 }
 return options
 }

 /// Comment Comment TLS Comment Comment p12 Comment Comment (server.p12)
 private static func loadIdentity() -> SecIdentity? {
 guard let url = Bundle.main.url(forResource: "server", withExtension: "p12"),
 let data = try? Data(contentsOf: url) else { return nil }
 let options: [String: Any] = [kSecImportExportPassphrase as String: "elite"]
 var items: CFArray?
 guard SecPKCS12Import(data as CFData, options as CFDictionary, &items) == errSecSuccess,
 let array = items as? [[String: Any]],
 let identity = array.first?[kSecImportItemIdentity as String] else {
 return nil
 }
 return (identity as! SecIdentity)
 }
}
