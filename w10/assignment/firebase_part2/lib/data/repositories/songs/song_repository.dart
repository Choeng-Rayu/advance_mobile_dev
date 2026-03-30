import '../../../model/songs/song.dart';

abstract class SongRepository {
  Future<List<Song>> fetchSongs();
  
  Future<Song?> fetchSongById(String id);
  
  Future<void> toggleLikeSong(String songId, bool currentLikedState);
}
