import 'package:calculated_life/app/app.dart';
import 'package:calculated_life/core/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_repositories.dart';

Future<void> pumpCalculatedLifeApp(
  WidgetTester tester, {
  required FakeRepositoriesBundle fakes,
  Size windowSize = const Size(1600, 1000),
}) async {
  tester.view.physicalSize = windowSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(() => fakes.dispose());

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(fakes.settingsRepository),
        notebookRepositoryProvider.overrideWithValue(fakes.notebookRepository),
        visionBoardRepositoryProvider.overrideWithValue(
          fakes.visionBoardRepository,
        ),
        plannerRepositoryProvider.overrideWithValue(fakes.plannerRepository),
        aiChatRepositoryProvider.overrideWithValue(fakes.aiChatRepository),
        secretStoreProvider.overrideWithValue(fakes.secretStore),
        aiClientProvider.overrideWithValue(fakes.aiClient),
        imageStorageServiceProvider.overrideWithValue(
          fakes.imageStorageService,
        ),
      ],
      child: const CalculatedLifeApp(),
    ),
  );

  await tester.pumpAndSettle();
}
