// Stub implementations for web - these won't be called
import 'package:dio/dio.dart';

class CookieJar {
  Future<void> deleteAll() async {
    // No-op on web
  }
}

class CookieManager extends Interceptor {
  CookieManager(CookieJar jar);
}

class PersistCookieJar extends CookieJar {
  PersistCookieJar({required dynamic storage});
}

class FileStorage {
  FileStorage(String path);
}

Future<dynamic> getApplicationDocumentsDirectory() async {
  throw UnsupportedError('Not supported on web');
}
