import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vietinfo_dev_core/core/path_locals.dart';

class FileService {
  Future<String> downloadFile({@required String urlFile,
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
      URL = urlFile.contains(linkDownload) ? urlFile : linkDownload + urlFile;
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

      if (await PathFileLocals().checkExistFile(path: file.path) == true &&
          file.lengthSync() > 0) {
        // File file = new File("${tempPath}/${fileName}");
        return file.path;
      } else {
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
        } else {
          var link =
          URL.contains(linkDownload ?? "") ? URL : linkDownload + URL;

          response = await dio.get(
            link,
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
        print("response.data = ${response.data}");
        await file.writeAsBytesSync(response.data);
      }
      return file.path;
    } catch (error) {
      throw (" downloadFile - $error");
      return null;
    }
  }

  Future<String> uploadFile({@required String path,
    @required String linkUpload,
    @required String keyUploadFile,
    Map<String, String> fields}) async {
    var postUri = Uri.parse(linkUpload);
    var request = new http.MultipartRequest("POST", postUri);
    if (fields != null) {
      for (var key in fields.keys) {
        request.fields[key] = fields[key];
      }
    }
    Uri uri = Uri(path: path);
    String fileName = path
        .split("/")
        ?.last;
    if (fileName == null || fileName == "") {
      fileName = path
          .split("\\")
          ?.last;
    }
    if (fileName.length > 55) {
      fileName =
      "${DateTime
          .now()
          .day}${DateTime
          .now()
          .month}${DateTime
          .now()
          .year}${DateTime
          .now()
          .hour}${DateTime
          .now()
          .minute}${DateTime
          .now()
          .microsecond}.${fileName
          .split(".")
          .last}";
    }

    request.files.add(new http.MultipartFile.fromBytes(
        keyUploadFile ?? 'file', await File.fromUri(uri).readAsBytes(),
        filename: fileName));
    try {
      http.StreamedResponse streamedResponse = await request.send();
      if (streamedResponse.statusCode != 200) {
        return null;
      }

      String urlFile = "";
      await streamedResponse.stream.transform(utf8.decoder).forEach((element) {
        if (element != null) {
          urlFile += element.toString();
        }
      });
      return urlFile;
    } catch (error) {
      throw (" downloadFile - $error");
      return null;
    }
  }

  Future<String> fileUploadMultipart({@required String path,
    @required String linkUpload,
    @required String keyUploadFile,
    @required Function uploadProgress,
    Map<String, String> fields}) async {
    assert(path != null);
    Uri uri = Uri(path: path);
    final url = linkUpload;
    final httpClient = getHttpClient();

    final request = await httpClient.postUrl(Uri.parse(url));

    int byteCount = 0;

    var multipart =
    await http.MultipartFile.fromPath(keyUploadFile ?? 'file', path);

    // final fileStreamFile = file.openRead();
    // var multipart = MultipartFile("file", fileStreamFile, file.lengthSync(),
    //     filename: fileUtil.basename(file.path));
    var requestMultipart = http.MultipartRequest("POST", Uri.parse(url));
    requestMultipart.files.add(multipart);
    if (fields != null) {
      for (var key in fields.keys) {
        requestMultipart.fields[key] = fields[key];
      }
    }

    var msStream = requestMultipart.finalize();

    var totalByteLength = requestMultipart.contentLength;

    request.contentLength = totalByteLength;

    request.headers.set(HttpHeaders.contentTypeHeader,
        requestMultipart.headers[HttpHeaders.contentTypeHeader]);

    Stream<List<int>> streamUpload = msStream.transform(
      new StreamTransformer.fromHandlers(
        handleData: (data, sink) async {
          sink.add(data);
          byteCount += data.length;
          double dataProgress = (byteCount / totalByteLength * 100);
          // print("dataProgress: ${dataProgress}");
          // if (dataProgress != 100.0)
          uploadProgress?.call(dataProgress);

          // if (onUploadProgress != null) {
          //   onUploadProgress(byteCount, totalByteLength);
          //   // CALL STATUS CALLBACK;
          // }
        },
        handleError: (error, stack, sink) {
          throw error;
        },
        handleDone: (sink) {
          sink.close();
          // UPLOAD DONE;
        },
      ),
    );

    await request.addStream(streamUpload);

    final httpResponse = await request.close();
//
    var statusCode = httpResponse.statusCode;

    if (statusCode ~/ 100 != 2) {
      throw Exception(
          'Error uploading file, Status code: ${httpResponse.statusCode}');
    } else {
      var aaaa = await readResponseAsString(httpResponse);
      return aaaa;
    }
  }

  static bool trustSelfSigned = true;

  static HttpClient getHttpClient() {
    HttpClient httpClient = new HttpClient()
      ..connectionTimeout = const Duration(seconds: 10)
      ..badCertificateCallback =
      ((X509Certificate cert, String host, int port) => trustSelfSigned);

    return httpClient;
  }

  static Future<String> readResponseAsString(
      HttpClientResponse response) async {
    String urlFile = "";
    await response.transform(utf8.decoder).forEach((element) {
      if (element != null) {
        urlFile += jsonDecode(element);
      }
    });
    return urlFile;
  }
}
