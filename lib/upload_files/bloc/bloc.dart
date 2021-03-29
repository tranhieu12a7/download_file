import 'package:download_file/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:progress_dialog/progress_dialog.dart';

class UploadFileBloc extends Cubit<Object> {
  FileService fileService;
  Function({String path, String linkUpload, BuildContext context, Map<String, String> fields,String keyUploadFile})
      startUploadFile;

  UploadFileBloc( ) : super(Object()) {
    fileService = FileService();

    startUploadFile =
        ({String path, String linkUpload, BuildContext context, Map<String, String> fields,String keyUploadFile}) async {
      final ProgressDialog progressDialog = ProgressDialog(context);
      progressDialog.style(message: "Đang tải...");

      await progressDialog.show();
      var pathResult =
          await fileService.uploadFile(path: path, linkUpload: linkUpload,fields: fields,keyUploadFile: keyUploadFile);
      await progressDialog.hide();
      return pathResult;
    };
  }
}
