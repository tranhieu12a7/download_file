import 'dart:async';
import 'package:download_file/download_files/models/model_download.dart';
import 'package:download_file/download_files/services/api_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DownloadFileBloc extends Cubit<Object> {
  StreamController<ModelDownload> streamController=StreamController<ModelDownload>.broadcast();

  Function( {String linkDownload, String path,ModelDownload modelDownload})
      startDownload;

  FileService fileService;

  DownloadFileBloc() : super(Object()) {
    fileService = FileService();

    startDownload =
        ({String linkDownload, String path,ModelDownload modelDownload}) async {

      var pathResult= await fileService.downloadFile(
          urlFile: modelDownload.urlFile,
          linkDownload: linkDownload,
          pathFolderFile: path,
          showDownloadProgress: (value) {
            streamController.sink.add(modelDownload.clone(value: value??0.0) );

          });
      if(pathResult!=null){
        streamController.sink.add(modelDownload.clone(value: 100.0) );
      }
      return pathResult;
    };
  }




  void dispose() {
    streamController.close();
  }
}
