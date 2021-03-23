import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vietinfo_dev_core/core/path_locals.dart';

class FileService {


  Future<String> downloadFile(
      {@required String urlFile,
      String linkDownload,
      Function(double) showDownloadProgress,
      String pathFolderFile = ""}) async {
    var param = new Map<String, String>();
    String URL = '';
    var temp = urlFile.split('/');
    String fileName = temp[temp.length - 1];
    if (urlFile.contains("Alfresco")) {
      URL = linkDownload;
      //URL = URL_DOWNLOAD_FILEAlfresco; print('URL file_response: $URL');
      param['fileUrl'] = urlFile;
      param['fileName'] = fileName;
    } else {
      URL = urlFile;
    }
    // url = 'Alfresco/HocMon/CPXD/49/2020/7/CPXD_49_20200715114132_bv(1).jpg';
    var dio = Dio();
    dio.interceptors.add(LogInterceptor());
    try {
      Response response;
      Directory tempDir;
      String tempPath;
      if (pathFolderFile?.isNotEmpty == true) {
        tempPath = pathFolderFile;
      } else {
        // Directory tempDir = await getTemporaryDirectory();
        tempDir =
            await PathFileLocals().getPathLocal(ePathType: EPathType.Download);
        // Directory tempDir = await getApplicationDocumentsDirectory();
        tempPath = tempDir.path;
      }

      File file = new File("${tempDir.path}/${fileName}");

      if (await PathFileLocals().checkExistFile(path:file.path) == true && file.lengthSync()>0) {
        // File file = new File("${tempPath}/${fileName}");
        return file.path;
      }
      else {
        if (param.length > 0) {
          response = await dio.post(
            URL,
            onReceiveProgress: (received, total) async {
              // String dataProgress = (received / total * 100).toStringAsFixed(0);
              double dataProgress = (received / total * 100);
              showDownloadProgress?.call(dataProgress);
            },
            options: Options(
                contentType: Headers.formUrlEncodedContentType,
                responseType: ResponseType.bytes,
                followRedirects: false,
                receiveTimeout: 0),
            data: param,
          );
        }
        else {
          var link= URL.contains(linkDownload ?? "") ? URL : linkDownload + URL ;

          response = await dio.get(link,
            onReceiveProgress: (received, total) async {
              // String dataProgress = (received / total * 100).toStringAsFixed(0);
              double dataProgress = (received / total * 100);
              showDownloadProgress?.call(dataProgress);
            },
            //Received data with List<int>
            options: Options(
                responseType: ResponseType.bytes,
                followRedirects: false,
                receiveTimeout: 0),
          );
        }

        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
        File file = new File("${tempPath}/${fileName}");

        file.writeAsBytesSync(response.data);
      }
      return file.path;
    } catch (error) {
      throw (" downloadFile - $error");
      return null;
    }
  }

  Future<http.ByteStream> uploadFile(
      {@required String path,
      @required String linkUpload,
      Map<String, String> fields}) async {
    var postUri = Uri.parse(linkUpload);
    var request = new http.MultipartRequest("POST", postUri);
    if (fields != null) {
      for (var key in fields.keys) {
        request.fields[key] = fields[key];
      }
    }
    Uri uri = Uri(path: path);
    String fileName = path.split("/")?.last;
    if (fileName == null || fileName == "") {
      fileName = path.split("\\")?.last;
    }
    request.files.add(new http.MultipartFile.fromBytes(
        'file', await File.fromUri(uri).readAsBytes(),
        filename: fileName));
    try {
      http.StreamedResponse streamedResponse = await request.send();
      if (streamedResponse.statusCode != 200) {
        return null;
      }
      return streamedResponse.stream;
    } catch (error) {
      throw (" downloadFile - $error");
      return null;
    }
  }
}
