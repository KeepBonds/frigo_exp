import 'StorageManager.dart';

StorageManager initManager() => throw UnsupportedError(
    'Cannot create a client without dart:html or dart:io.');

/// Implemented in `browser_client.dart` and `io_client.dart`.
StorageManager createManager() => throw UnsupportedError(
    'Cannot create a client without dart:html or dart:io.');