
import 'dart:async';

import 'package:flutter/services.dart';

class DownloadFile {
  static const MethodChannel _channel =
      const MethodChannel('download_file');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
