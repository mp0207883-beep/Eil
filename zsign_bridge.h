//
// zsign_bridge.h
// Comment Comment Comment zsign (C++) Comment Comment Swift Comment Comment C
//

#ifndef zsign_bridge_h
#define zsign_bridge_h

#ifdef __cplusplus
extern "C" {
#endif

/// Sign IPA
/// @return 0 Comment Comment Comment Comment Comment Comment CommentFailed
int zsign_sign(const char* ipaPath,
 const char* p12Path,
 const char* provPath,
 const char* password,
 const char* outputPath,
 const char* newBundleId, // "" Info
 const char* newBundleName, // "" Info
 const char* newIconPath, // "" Info
 const char** dylibs, // Info Info Info NULL
 int dylibCount);

/// Comment Comment Certificate Comment OCSP
/// @return 0 Comment 1 Comment 2 Comment -1 Comment
int zsign_check_cert(const char* p12Path,
 const char* password,
 char* outStatus,
 int outLen);

#ifdef __cplusplus
}
#endif

#endif /* zsign_bridge_h */
