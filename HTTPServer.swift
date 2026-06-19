//
// HTTPServer.swift
// Comment HTTPS Comment Comment (TCP + TLS) Comment Comment CommentInstall Comment
// CommentDoneComment Comment Network.framework Comment Apple.
//

import Foundation
import Network

final class HTTPServer {
 private var listener: NWListener?
 private var routes: [String: (data: Data, contentType: String)] = [:]
 private var fileRoutes: [String: (url: URL, contentType: String)] = [:]
 private(set) var port: UInt16 = 0

 /// Comment Comment Comment Comment Comment Comment
 func route(_ path: String, data: Data, contentType: String) {
 routes[path] = (data, contentType)
 }

 /// Comment Comment Comment Comment Comment Comment (Comment Comment Comment IPA)
 func route(_ path: String, fileURL: URL, contentType: String) {
 fileRoutes[path] = (fileURL, contentType)
 }

 /// Comment Comment Comment Comment Comment Comment Comment Comment
 @discardableResult
 func start() throws -> UInt16 {
 // Comment: itms-services Comment HTTPS. Comment Comment TLS Comment Comment CommentSign
 // Comment Comment Comment (TLSManager). Comment Comment Comment Comment.
 let params = NWParameters(tls: TLSManager.serverTLSOptions(), tcp: .init())
 let listener = try NWListener(using: params)
 self.listener = listener

 listener.newConnectionHandler = { [weak self] conn in
 self?.handle(conn)
 }
 let sem = DispatchSemaphore(value: 0)
 listener.stateUpdateHandler = { [weak self] state in
 if case .ready = state {
 self?.port = listener.port?.rawValue ?? 0
 sem.signal()
 }
 }
 listener.start(queue: .global())
 _ = sem.wait(timeout: .now() + 5)
 return port
 }

 private func handle(_ conn: NWConnection) {
 conn.start(queue: .global())
 conn.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [weak self] data, _, _, _ in
 guard let self, let data, let req = String(data: data, encoding: .utf8) else {
 conn.cancel(); return
 }
 // Comment Comment Comment: GET /path HTTP/1.1
 let path = req.split(separator: " ").dropFirst().first.map(String.init) ?? "/"

 if let route = self.routes[path] {
 self.respond(conn, body: route.data, contentType: route.contentType)
 } else if let file = self.fileRoutes[path],
 let fileData = try? Data(contentsOf: file.url) {
 self.respond(conn, body: fileData, contentType: file.contentType)
 } else {
 self.respond(conn, body: Data("Not Found".utf8), contentType: "text/plain", status: "404 Not Found")
 }
 }
 }

 private func respond(_ conn: NWConnection, body: Data, contentType: String, status: String = "200 OK") {
 var header = "HTTP/1.1 \(status)\r\n"
 header += "Content-Type: \(contentType)\r\n"
 header += "Content-Length: \(body.count)\r\n"
 header += "Connection: close\r\n\r\n"
 var out = Data(header.utf8)
 out.append(body)
 conn.send(content: out, completion: .contentProcessed { _ in
 conn.cancel()
 })
 }

 func stop() {
 listener?.cancel()
 listener = nil
 }
}
