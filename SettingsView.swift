//
// SettingsView.swift
// Settings: Import CertificateComment Comment IPAComment Certificate ManagementComment Comment Comment (Comment Comment)
//

import SwiftUI

struct SettingsView: View {
 @EnvironmentObject var appState: AppState
 @StateObject private var vm = SettingsViewModel()

 private let telegramURL = URL(string: "https://t.me/EliteIPA")!

 var body: some View {
 NavigationStack {
 ZStack {
 Theme.backgroundGradient.ignoresSafeArea()
 ScrollView {
 VStack(spacing: 16) {
 // Import Certificate
 OptionButton(icon: "key.fill", title: "Import Certificate (.p12 + provision)", color: Theme.accent) {
 vm.showCertImporter = true
 }
 // Comment Apps IPA
 OptionButton(icon: "square.and.arrow.down.fill", title: "Import App (IPA)", color: .orange) {
 vm.showIPAImporter = true
 }

 // Comment Comment
 if !appState.certificates.isEmpty {
 VStack(alignment: .leading, spacing: 10) {
 Text("Info").font(.caption).foregroundColor(Theme.textSecondary)
 ForEach(appState.certificates) { cert in
 CertRow(cert: cert,
 onActivate: { vm.activate(cert, appState: appState) },
 onCheck: { vm.check(cert, appState: appState) },
 onDelete: { vm.delete(cert, appState: appState) })
 }
 }.padding().glassCard()
 }

 OptionButton(icon: "trash.fill", title: "Info Files Info", color: Theme.danger) {
 vm.clearCache()
 }

 // Comment Comment Comment Comment Comment Comment
 Link(destination: telegramURL) {
 HStack(spacing: 14) {
 Image(systemName: "paperplane.fill").foregroundColor(Theme.accent).frame(width: 28)
 VStack(alignment: .leading) {
 Text("Telegram Channel").foregroundColor(Theme.textPrimary)
 Text("t.me/EliteIPA").font(.caption).foregroundColor(Theme.textSecondary)
 }
 Spacer()
 Image(systemName: "arrow.up.left.square.fill").foregroundColor(Theme.textSecondary)
 }
 .padding().glassCard()
 }

 Text("Elite IPA Version 1.0").font(.caption2).foregroundColor(Theme.textSecondary).padding(.top, 8)
 }
 .padding()
 }
 }
 .navigationTitle("Settings")
 .fileImporter(isPresented: $vm.showCertImporter, allowedContentTypes: [.item], allowsMultipleSelection: true) { result in
 vm.handleCertImport(result)
 }
 .fileImporter(isPresented: $vm.showIPAImporter, allowedContentTypes: [.item], allowsMultipleSelection: false) { result in
 vm.handleIPAImport(result, appState: appState)
 }
 .alert("Info Info Certificate", isPresented: $vm.askPassword) {
 SecureField("Password", text: $vm.passwordInput)
 Button("Save") { vm.savePassword(appState: appState) }
 Button("Cancel", role: .cancel) { vm.cancelCertImport() }
 } message: {
 Text("Info Info Info CertificateInfo InfoDone Info Info Info.")
 }
 .alert(vm.alertTitle, isPresented: $vm.showAlert) {
 Button("OK") {}
 } message: { Text(vm.alertMessage) }
 }
 }
}

struct CertRow: View {
 let cert: SigningCertificate
 let onActivate: () -> Void
 let onCheck: () -> Void
 let onDelete: () -> Void

 var statusColor: Color {
 switch cert.status {
 case .valid: return Theme.accentGreen
 case .revoked, .expired: return Theme.danger
 case .unknown: return Theme.textSecondary
 }
 }

 var body: some View {
 HStack(spacing: 12) {
 Image(systemName: cert.isActive ? "checkmark.circle.fill" : "circle")
 .foregroundColor(cert.isActive ? Theme.accentGreen : Theme.textSecondary)
 .onTapGesture { onActivate() }
 VStack(alignment: .leading, spacing: 3) {
 Text(cert.name).foregroundColor(Theme.textPrimary).font(.subheadline)
 HStack(spacing: 6) {
 Circle().fill(statusColor).frame(width: 7, height: 7)
 Text(cert.status.arabicLabel).font(.caption).foregroundColor(statusColor)
 }
 }
 Spacer()
 Button { onCheck() } label: { Image(systemName: "arrow.clockwise").foregroundColor(Theme.accent) }
 Button { onDelete() } label: { Image(systemName: "trash").foregroundColor(Theme.danger) }
 }
 .padding(.vertical, 6)
 }
}
