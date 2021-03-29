import 'dart:async';

import 'package:download_file/upload_files/bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'download_files/blocs/bloc.dart';
export 'package:download_file/download_files/blocs/bloc.dart';
export 'package:download_file/download_files/models/model_download.dart';
export 'package:download_file/download_files/widgets/widget_download_file.dart';
export 'package:download_file/upload_files/bloc/bloc.dart';

class DownloadFile {
  static DownloadFileBloc downloadFileBloc;
  static UploadFileBloc uploadFileBloc;

  static initUploadFile({BuildContext context}) {
    uploadFileBloc = BlocProvider.of<UploadFileBloc>(context);
  }

  static const MethodChannel _channel = const MethodChannel('download_file');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
