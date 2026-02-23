import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'db/app_database.dart';
import 'repositories/drift_repositories.dart';
import 'repositories/interfaces.dart';
import 'services/image_storage_service.dart';
import 'services/openai_client.dart';
import 'services/secret_store.dart';

final uuidProvider = Provider<Uuid>((ref) => const Uuid());

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsDriftRepository(ref.watch(appDatabaseProvider)),
);

final notebookRepositoryProvider = Provider<NotebookRepository>(
  (ref) => NotebookDriftRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(uuidProvider),
  ),
);

final visionBoardRepositoryProvider = Provider<VisionBoardRepository>(
  (ref) => VisionBoardDriftRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(uuidProvider),
  ),
);

final plannerRepositoryProvider = Provider<PlannerRepository>(
  (ref) => PlannerDriftRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(uuidProvider),
  ),
);

final aiChatRepositoryProvider = Provider<AiChatRepository>(
  (ref) => AiChatDriftRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(uuidProvider),
  ),
);

final secretStoreProvider = Provider<SecretStore>(
  (ref) => createDefaultSecretStore(),
);

final aiClientProvider = Provider<AiClient>((ref) => OpenAiResponsesClient());

final imageStorageServiceProvider = Provider<ImageStorageService>((ref) {
  return ImageStorageService(uuid: ref.watch(uuidProvider));
});

class ScrapperSessionNotifier extends StateNotifier<String>
    implements ScrapperSessionService {
  ScrapperSessionNotifier() : super('');

  @override
  String get text => state;

  @override
  void clear() {
    state = '';
  }

  @override
  void setText(String value) {
    state = value;
  }
}

final scrapperSessionProvider =
    StateNotifierProvider<ScrapperSessionNotifier, String>(
      (ref) => ScrapperSessionNotifier(),
    );
