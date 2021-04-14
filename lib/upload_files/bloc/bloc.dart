import 'dart:async';

import 'package:download_file/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:progress_dialog/progress_dialog.dart';

class UploadFileBloc extends Cubit<Object> {
  StreamController<double> streamController;

  FileService fileService;
  Function(
      {String path,
      String linkUpload,
      Map<String, String> fields,
      String keyUploadFile}) startUploadFile;

  UploadFileBloc() : super(Object()) {
    fileService = FileService();
    streamController = StreamController.broadcast();
    startUploadFile = (
        {String path,
        String linkUpload,
        Map<String, String> fields,
        String keyUploadFile}) async {
      // final ProgressDialog progressDialog = ProgressDialog(context);
      // progressDialog.style(message: "Đang tải...");

      // await progressDialog.show();
      // var pathResult =
      //     await fileService.uploadFile(path: path, linkUpload: linkUpload,fields: fields,keyUploadFile: keyUploadFile);
      var pathResult = await fileService.fileUploadMultipart(
          path: path,
          linkUpload: linkUpload,
          fields: fields,
          keyUploadFile: keyUploadFile,
          uploadProgress: (valueProgress) {
            streamController.sink.add(valueProgress);
          });
      // await progressDialog.hide();
      return pathResult;
    };
  }

  void dispose() {
    streamController.close();
  }
}
