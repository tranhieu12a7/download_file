
import 'dart:async';

import 'package:flutter/services.dart';

import 'download_files/blocs/bloc.dart';
export 'package:download_file/download_files/blocs/bloc.dart';
export 'package:download_file/download_files/models/model_download.dart';
export 'package:download_file/download_files/widgets/widget_download_file.dart';

class DownloadFile{

  static DownloadFileBloc downloadFileBloc;

  static const MethodChannel _channel =
      const MethodChannel('download_file');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
