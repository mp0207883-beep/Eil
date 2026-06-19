//
// zsign_bridge.cpp
// Comment Comment Comment Comment zsign Comment (Comment zhlynn/zsign)
//
// Comment: Comment CommentBuild Comment Comment zsign (Comment src) Comment Comment Comment Comment Comment
// Comment ZSignAsset / ZAppBundle Comment Comment zsign Comment CommentSign.
// Comment Comment Comment Comment Comment Comment common/ Comment bundle.
//

#include "zsign_bridge.h"
#include <string>
#include <vector>
#include <cstring>

// Comment zsign Comment (Comment Comment Comment Comment src Comment Comment zsign)
#include "openssl.h"
#include "signing.h"
#include "bundle.h"
#include "common/common.h"

int zsign_sign(const char* ipaPath,
 const char* p12Path,
 const char* provPath,
 const char* password,
 const char* outputPath,
 const char* newBundleId,
 const char* newBundleName,
 const char* newIconPath,
 const char** dylibs,
 int dylibCount)
{
 try {
 ZSignAsset zSignAsset;
 // Comment Comment Certificate Comment Comment
 if (!zSignAsset.Init("", p12Path, provPath, "", password ? password : "", false)) {
 return 10; // Failed Info Certificate
 }

 // Comment Comment Comment IPA Comment Comment Comment Comment
 std::string strFolder = std::string(outputPath) + ".work";
 ZIPDirectory(ipaPath, strFolder.c_str()); // Info Info Info zsign Info Info

 // Comment Comment dylibs
 std::vector<std::string> arrDyLibFiles;
 if (dylibs) {
 for (int i = 0; i < dylibCount && dylibs[i] != nullptr; i++) {
 arrDyLibFiles.push_back(std::string(dylibs[i]));
 }
 }

 std::string bundleId = (newBundleId && strlen(newBundleId)) ? newBundleId : "";
 std::string bundleName = (newBundleName && strlen(newBundleName)) ? newBundleName : "";

 // Comment Comment Comment Comment CommentSign
 ZAppBundle bundle;
 bool ok = bundle.SignFolder(&zSignAsset,
 strFolder,
 bundleId,
 bundleName,
 "", // bundle version
 arrDyLibFiles,
 true, // force
 false, // weak inject
 false); // adhoc
 if (!ok) return 20;

 // Comment Comment Comment Comment IPA
 if (!ZipFolder(strFolder.c_str(), outputPath)) {
 return 30;
 }

 // (Comment) Comment Comment Comment Comment Comment CommentDone Comment SignFolder Comment DoneComment Comment
 (void)newIconPath;

 RemoveFolder(strFolder.c_str());
 return 0;
 } catch (...) {
 return -1;
 }
}

int zsign_check_cert(const char* p12Path,
 const char* password,
 char* outStatus,
 int outLen)
{
 try {
 ZSignAsset zSignAsset;
 if (!zSignAsset.Init("", p12Path, "", "", password ? password : "", false)) {
 if (outStatus && outLen > 0) strncpy(outStatus, "load_failed", outLen - 1);
 return -1;
 }

 // Comment Comment Certificate Comment OCSP (Comment Comment zsign)
 int ocsp = zSignAsset.CheckCertificateOCSP(); // 0 Info 1 Info
 if (ocsp == 1) {
 if (outStatus && outLen > 0) strncpy(outStatus, "revoked", outLen - 1);
 return 1;
 }

 // Comment Comment
 if (zSignAsset.IsExpired()) {
 if (outStatus && outLen > 0) strncpy(outStatus, "expired", outLen - 1);
 return 2;
 }

 if (outStatus && outLen > 0) strncpy(outStatus, "valid", outLen - 1);
 return 0;
 } catch (...) {
 if (outStatus && outLen > 0) strncpy(outStatus, "error", outLen - 1);
 return -1;
 }
}
