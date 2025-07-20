import 'dart:io';

String readFixtureFromFileName(String name) =>
    File('test/fixtures/$name').readAsStringSync();
