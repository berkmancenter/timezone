// Copyright (c) 2014, the timezone project authors. Please see the AUTHORS
// file for details. All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

/// TimeZone initialization for standalone environments.
///
/// ```dart
/// import 'package:timezone/standalone.dart';
///
/// initializeTimeZone().then((_) {
///  final detroit = getLocation('America/Detroit');
///  final now = new TZDateTime.now(detroit);
/// });
/// ```
library timezone.standalone;

import 'dart:async';
import 'dart:isolate';
import 'package:path/path.dart' as p;
import 'package:timezone/timezone.dart';
import 'package:node_io/node_io.dart';
export 'package:timezone/timezone.dart'
    show
        getLocation,
        setLocalLocation,
        TZDateTime,
        Location,
        TimeZone,
        timeZoneDatabase;

final String tzDataDefaultPath = p.join('data', tzDataDefaultFilename);

// Load file
Future<List<int>> _loadAsBytes(String path) async {
  var uri = await Isolate.resolvePackageUri(
      Uri(scheme: 'package', path: 'timezone/$path'));
  return File(p.fromUri(uri)).readAsBytes();
}

/// Initialize Time Zone database.
///
/// Throws [TimeZoneInitException] when something is worng.
///
/// ```dart
/// import 'package:timezone/standalone.dart';
///
/// initializeTimeZone().then(() {
///   final detroit = getLocation('America/Detroit');
///   final detroitNow = new TZDateTime.now(detroit);
/// });
/// ```
Future<void> initializeTimeZone([String path]) {
  path ??= tzDataDefaultPath;
  return _loadAsBytes(path).then((rawData) {
    initializeDatabase(rawData);
  }).catchError((dynamic e) {
    throw TimeZoneInitException(e.toString());
  });
}
