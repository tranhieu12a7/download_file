import 'dart:io';

import 'package:download_file/download_files/blocs/bloc.dart';
import 'package:download_file/download_files/models/model_download.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vietinfo_dev_core/core/path_locals.dart';

import '../../download_file.dart';

class WidgetDownloadFileMain extends StatelessWidget {
  final String urlFile;
  final AsyncWidgetBuilder<ModelDownload> builder;

  const WidgetDownloadFileMain({Key key, this.urlFile, this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: WidgetDownloadFile(
        builder: builder,
        urlFile: urlFile,
      ),
      create: (context) => DownloadFileBloc(),
    );
  }
}

class WidgetDownloadFile extends StatefulWidget {
  final String urlFile;
  final BuildContext buildContext;
  final AsyncWidgetBuilder<ModelDownload> builder;

  WidgetDownloadFile({Key key, this.urlFile, this.buildContext, this.builder})
      : super(key: key);

  @override
  _WidgetDownloadFileState createState() => _WidgetDownloadFileState();
}

class _WidgetDownloadFileState extends State<WidgetDownloadFile> {
  DownloadFileBloc bloc;

  UploadFileBloc blocUpload;

  ModelDownload modelDownload;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = BlocProvider.of<DownloadFileBloc>(widget.buildContext);
    blocUpload = BlocProvider.of<UploadFileBloc>(widget.buildContext);
    DownloadFile.downloadFileBloc = bloc;
    DownloadFile.uploadFileBloc = blocUpload;
    modelDownload = new ModelDownload(value: 0.0, urlFile: widget.urlFile);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // bloc.dispose();
  }

  checkFile(String urlFile) async {
    try {
      var temp = urlFile.split('/');
      String fileName = temp[temp.length - 1];
      var tempDir =
          await PathFileLocals().getPathLocal(ePathType: EPathType.Download);
      File file = new File("${tempDir.path}/${fileName}");
      if (await PathFileLocals().checkExistFile(path: file.path) == true) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkFile(modelDownload.urlFile),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data) {
            widget.builder.call(
                context,
                AsyncSnapshot<ModelDownload>.withData(
                    ConnectionState.done, modelDownload.clone(value: 100.0)));
          }
          return StreamBuilder(
            builder: widget.builder,
            stream: bloc.streamController.stream,
          );
          // return  childChange.call(modelDownload.clone(value: 0.0));
        }
        return SizedBox(
          height: MediaQuery.of(context).size.width/4,
          width: MediaQuery.of(context).size.width/4,
          child: CircularProgressIndicator(
            strokeWidth: 1.0,
          ),
        );
      },
    );
  }
}
