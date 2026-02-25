import 'package:provider/provider.dart';
import 'package:small_homework/data/repositories/songs/song_repository_remote.dart';
// import 'package:x_code/spotify/part_1_repositories/data/repositories/songs/song_repository_mock.dart';
import './data/repositories/songs/song_repository_mock.dart';

import 'data/repositories/songs/song_repository.dart';
import 'main_common.dart';
import './data/repositories/songs/song_repository_composite.dart';
// import './data/repositories/songs/song_repository_mock.dart';

/// Configure provider dependencies for dev environement

List<Provider> get providersLocal {
  return [
    Provider<SongRepository>(create: (context) => SongRepositoryMock()),
    Provider<SongRepositoryRemote>(create: (context) => SongRepositoryRemote()),
  ];
}


///This si provider is for me display both song that i have implement the song_repository_composite for display both
// List<Provider> get providersLocal {
//   return [
//     Provider<SongRepositoryComposite>(create: (context) => SongRepositoryComposite()),
//     Provider<SongRepositoryComposite>(create: (context) => SongRepositoryComposite()),
//   ];
// }

void main() {
  mainCommon(providersLocal);
}
