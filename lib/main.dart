import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/ai/dev_key_seed.dart';
import 'core/security/api_key_vault.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await seedDevApiKeysIfPresent(ApiKeyVault.instance);
  runApp(const ProviderScope(child: DpbsHubApp()));
}
