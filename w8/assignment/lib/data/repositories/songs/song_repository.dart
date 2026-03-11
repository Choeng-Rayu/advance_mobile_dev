import '../../../model/songs/song.dart';
import '../../../model/async_value.dart';

abstract class SongRepository {
  Future<AsyncValue<List<Song>>> fetchSongs();

  Future<Song?> fetchSongById(String id);
}
