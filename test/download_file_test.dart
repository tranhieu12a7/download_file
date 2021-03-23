import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:download_file/download_file.dart';

void main() {
  const MethodChannel channel = MethodChannel('download_file');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await DownloadFile.platformVersion, '42');
  });
}
