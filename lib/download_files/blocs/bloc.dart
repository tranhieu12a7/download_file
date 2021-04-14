import 'dart:async';
import 'package:download_file/download_files/models/model_download.dart';
import 'package:download_file/services/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DownloadFileBloc extends Cubit<Object> {
  StreamController<ModelDownload> streamController;
  Function({String linkDownload, String path, ModelDownload modelDownload})
      startDownloadByWidget;

  Function({String linkDownload, String path, ModelDownload modelDownload,BuildContext context})
      startDownloadAndOpenFile;

  FileService fileService;

  DownloadFileBloc() : super(Object()) {
    fileService = FileService();
    streamController = StreamController.broadcast();

    startDownloadAndOpenFile = (
        {BuildContext context,
        String linkDownload,
        String path,
        ModelDownload modelDownload}) async {
      final ProgressDialog progressDialog =
          ProgressDialog(context);
      progressDialog.style(message: "Đang tải...");
      await progressDialog.show();
      var pathResult = await fileService.downloadFile(
          urlFile: modelDownload.urlFile,
          linkDownload: linkDownload,
          pathFolderFile: path,
          showDownloadProgress: (value) {
            // streamController.sink.add(modelDownload.clone(value: value ?? 0.0));
          });
      // if (pathResult != null) {
      //   // streamController.sink.add(modelDownload.clone(value: 100.0));
      // }
      await progressDialog.hide();
      await OpenFile.open(pathResult);
      return pathResult;
    };

    startDownloadByWidget = (
        {String linkDownload, String path, ModelDownload modelDownload}) async {
      var pathResult = await fileService.downloadFile(
          urlFile: modelDownload.urlFile,
          linkDownload: linkDownload,
          pathFolderFile: path,
          showDownloadProgress: (value) {
            streamController.sink.add(modelDownload.clone(value: value ?? 0.0));
          });
      if (pathResult != null) {
        streamController.sink.add(modelDownload.clone(value: 100.0));
      }
      return pathResult;
    };
  }

  void dispose() {
    streamController.close();
  }
}
