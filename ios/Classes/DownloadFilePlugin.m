#import "DownloadFilePlugin.h"
#if __has_include(<download_file/download_file-Swift.h>)
#import <download_file/download_file-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "download_file-Swift.h"
#endif

@implementation DownloadFilePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDownloadFilePlugin registerWithRegistrar:registrar];
}
@end
