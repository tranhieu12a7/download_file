class ModelDownload {
  final double value;
  final double valueUpload;
  final String key;
  final String urlFile;

  ModelDownload({this.value,this.valueUpload, this.key, this.urlFile});

  ModelDownload clone({value,valueUpload, key, urlFile}) {
    return ModelDownload(
        value: value ?? this.value,
        valueUpload: valueUpload ?? this.valueUpload,
        key: key ?? this.key,
        urlFile: urlFile ?? this.urlFile);
  }
}
