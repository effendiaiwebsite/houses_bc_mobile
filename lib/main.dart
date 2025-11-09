import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/storage/secure_storage.dart';
import 'app.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  await SecureStorageService.instance.init();

  // Run app
  runApp(
    const ProviderScope(
      child: HousesBCApp(),
    ),
  );
}
