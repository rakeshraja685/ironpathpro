import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'views/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  
  final container = ProviderContainer();
  final notifications = container.read(notificationServiceProvider);
  await notifications.init();
  await notifications.requestPermissions();
  
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const IronPathApp(),
    ),
  );
}
