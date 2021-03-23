class ModelDownload {
  final double value;
  final String key;
  final String urlFile;

  ModelDownload({this.value, this.key, this.urlFile});

  ModelDownload clone({value, key, urlFile}) {
    return ModelDownload(
        value: value ?? this.value,
        key: key ?? this.key,
        urlFile: urlFile ?? this.urlFile);
  }
}
