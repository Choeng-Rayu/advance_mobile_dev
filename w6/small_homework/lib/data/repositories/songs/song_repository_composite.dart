import '../../../model/song.dart';
import 'song_repository.dart';
import 'song_repository_mock.dart';
import 'song_repository_remote.dart';

class SongRepositoryComposite implements SongRepository {
  final SongRepositoryMock _mockRepo = SongRepositoryMock();
  final SongRepositoryRemote _remoteRepo = SongRepositoryRemote();

  @override
  List<Song> fetchSongs() {
    final mockSongs = _mockRepo.fetchSongs();
    final remoteSongs = _remoteRepo.fetchSongs();
    return [...mockSongs, ...remoteSongs];
  }

  @override
  Song? fetchSongById(String id) {
    return _mockRepo.fetchSongById(id) ?? _remoteRepo.fetchSongById(id);
  }
}
