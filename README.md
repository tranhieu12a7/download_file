# vietinfo_download_file
 

example code :
         //cần khai báo:
         ModelDownload modelDownload;

        //add widget vào chổ cần dùng (widget bên dưới dùng cho trường hợp multi bloc, cần khai báo DownloadFileBloc )
         WidgetDownloadFile(
            urlFile: widget.data.message,
            builder: (context, AsyncSnapshot<ModelDownload> snapshot) {
              if (!snapshot.hasData) {
              // widget default when start widget
                return GestureDetector(
                    onTap: () async {
                      var aaa = await DownloadFile
                          .downloadFileBloc.startDownload
                          .call(
                              linkDownload: "link download your if have",
                              modelDownload: new ModelDownload(
                                  value: 0.0, urlFile: "url file your"));
                      print("$aaa");
                    },
                    child: Icon(Icons.download_rounded));
              }
              if (snapshot.data.urlFile.contains("url file your")) {
                modelDownload = snapshot.data;
              }
              if (modelDownload.value >= 100) {
                return GestureDetector(
                    onTap: () async {
                      // Function( String urlFile, {String linkDownload, String path})
                      String aaa = await DownloadFile
                          .downloadFileBloc.startDownload
                          .call(
                              linkDownload: "link download your if have",
                              modelDownload: modelDownload);
                      await OpenFile.open(aaa);
                    },
                    child: Icon(
                      Icons.download_done_outlined,
                      color: Colors.green,
                    ));
              } else if (modelDownload.value > 0) {
                return CircularPercentIndicator(
                  radius: 20.0,
                  lineWidth: 5.0,
                  percent: modelDownload.value / 100.0,
                  progressColor: Colors.green,
                );
              } else {
                return GestureDetector(
                    onTap: () async {
                      var aaa = await DownloadFile
                          .downloadFileBloc.startDownload
                          .call(
                              linkDownload: "link download your if have",
                              modelDownload: modelDownload);
                    },
                    child: Icon(Icons.download_rounded));
              }
            },
          )


          //add widget vào chổ cần dùng (widget bên dưới dùng cho trường hợp thông thường chỉ down 1 lần, cần khai báo DownloadFileBloc )
                   WidgetDownloadFileMain(
                      urlFile: widget.data.message,
                      builder: (context, AsyncSnapshot<ModelDownload> snapshot) {
                        if (!snapshot.hasData) {
                        // widget default when start widget
                          return GestureDetector(
                              onTap: () async {
                                var aaa = await DownloadFile
                                    .downloadFileBloc.startDownload
                                    .call(
                                        linkDownload: "link download your if have",
                                        modelDownload: new ModelDownload(
                                            value: 0.0, urlFile: "url file your"));
                                print("$aaa");
                              },
                              child: Icon(Icons.download_rounded));
                        }
                        if (snapshot.data.urlFile.contains("url file your")) {
                          modelDownload = snapshot.data;
                        }
                        if (modelDownload.value >= 100) {
                          return GestureDetector(
                              onTap: () async {
                                // Function( String urlFile, {String linkDownload, String path})
                                String aaa = await DownloadFile
                                    .downloadFileBloc.startDownload
                                    .call(
                                        linkDownload: "link download your if have",
                                        modelDownload: modelDownload);
                                await OpenFile.open(aaa);
                              },
                              child: Icon(
                                Icons.download_done_outlined,
                                color: Colors.green,
                              ));
                        } else if (modelDownload.value > 0) {
                          return CircularPercentIndicator(
                            radius: 20.0,
                            lineWidth: 5.0,
                            percent: modelDownload.value / 100.0,
                            progressColor: Colors.green,
                          );
                        } else {
                          return GestureDetector(
                              onTap: () async {
                                var aaa = await DownloadFile
                                    .downloadFileBloc.startDownload
                                    .call(
                                        linkDownload: "link download your if have",
                                        modelDownload: modelDownload);
                              },
                              child: Icon(Icons.download_rounded));
                        }
                      },
                    )

