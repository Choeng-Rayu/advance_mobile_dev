import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../data/repositories/artists/artist_repository.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../../model/songs/song_with_artist.dart';
import '../../../../model/artists/artist.dart';
import '../../../utils/async_value.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;
  final PlayerState playerState;

  AsyncValue<List<SongWithArtist>> songsValue = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository,
    required this.artistRepository,
    required this.playerState,
  }) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong() async {
    // 1- Loading state
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Fetch songs and artists in parallel
      final results = await Future.wait([
        songRepository.fetchSongs(),
        artistRepository.fetchArtists(),
      ]);

      List<Song> songs = results[0] as List<Song>;
      List<Artist> artists = results[1] as List<Artist>;

      // 3- Create artist lookup map
      Map<String, Artist> artistMap = {
        for (var artist in artists) artist.id: artist,
      };

      // 4- Join songs with artists
      List<SongWithArtist> songsWithArtists = songs.map((song) {
        Artist? artist = artistMap[song.artist];
        if (artist == null) {
          // Fallback if artist not found
          artist = Artist(
            id: song.artist,
            name: 'Unknown Artist',
            genre: 'Unknown',
            imageUrl: song.imageUrl,
          );
        }
        return SongWithArtist.fromSongAndArtist(song, artist);
      }).toList();

      songsValue = AsyncValue.success(songsWithArtists);
    } catch (e) {
      // 3- Fetch is unsucessfull
      songsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  bool isSongPlaying(SongWithArtist song) =>
      playerState.currentSong?.id == song.id;

  void start(SongWithArtist song) {
    // Convert SongWithArtist back to Song for PlayerState
    final songForPlayer = Song(
      id: song.id,
      title: song.title,
      artist: song.artistId,
      duration: song.duration,
      imageUrl: song.songImageUrl,
    );
    playerState.start(songForPlayer);
  }

  void stop(SongWithArtist song) => playerState.stop();
}
