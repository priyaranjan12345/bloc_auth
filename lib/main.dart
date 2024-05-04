import 'package:bloc_auth/injection_container.dart';
import 'package:flutter/material.dart';

import 'auth_app.dart';

void main() async {
  // show splash screen
  await init();
  runApp(const AuthApp());
  // after all remove splash screen
}
