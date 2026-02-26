import 'package:provider/provider.dart';
import 'package:nested/nested.dart';

import 'main_common.dart';
import 'data/repositories/songs/song_repository.dart';
import 'data/repositories/songs/song_repository_mock.dart';
import 'ui/states/settings_state.dart';
import './ui/states/player_state.dart';

/// Configure provider dependencies for dev environment
List<SingleChildWidget> get devProviders {
  return [
    // 1 - Inject the song repository
    Provider<SongRepository>(create: (_) => SongRepositoryMock()),

    // 3 - Inject the  app setting state
    ChangeNotifierProvider<AppSettingsState>(create: (_) => AppSettingsState()),

    // 2 - Inject the play song state
    ChangeNotifierProvider<PlayerState>(create: (context) => PlayerState()),
  ];
}

void main() {
  mainCommon(devProviders);
}
