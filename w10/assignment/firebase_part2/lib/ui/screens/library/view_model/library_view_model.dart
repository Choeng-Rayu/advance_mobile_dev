import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';
import 'library_item_data.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;

  final PlayerState playerState;

  AsyncValue<List<LibraryItemData>> data = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository,
    required this.playerState,
    required this.artistRepository,
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

  void fetchSong({bool forceFetch = false}) async {
    // 1- Loading state
    data = AsyncValue.loading();
    notifyListeners();

    try {
      // 1- Fetch songs
      List<Song> songs = await songRepository.fetchSongs(
        forceFetch: forceFetch,
      );

      // 2- Fethc artist
      List<Artist> artists = await artistRepository.fetchArtists(
        forceFetch: forceFetch,
      );

      // 3- Create the mapping artistid-> artist
      Map<String, Artist> mapArtist = {};
      for (Artist artist in artists) {
        mapArtist[artist.id] = artist;
      }

      List<LibraryItemData> data = songs
          .map(
            (song) =>
                LibraryItemData(song: song, artist: mapArtist[song.artistId]!),
          )
          .toList();

      this.data = AsyncValue.success(data);
    } catch (e) {
      // 3- Fetch is unsucessfull
      data = AsyncValue.error(e);
    }
    notifyListeners();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();

  Future<void> toggleLikeSong(String songId, bool currentLikedState) async {
    try {
      // Optimistically update the UI
      if (data.state == AsyncValueState.success) {
        List<LibraryItemData> currentData = data.data!;
        List<LibraryItemData> updatedData = currentData.map((item) {
          if (item.song.id == songId) {
            return LibraryItemData(
              song: item.song.copyWith(isLiked: !currentLikedState),
              artist: item.artist,
            );
          }
          return item;
        }).toList();

        this.data = AsyncValue.success(updatedData);
        notifyListeners();
      }

      // Call repository to update Firebase
      await songRepository.toggleLikeSong(songId, currentLikedState);
    } catch (e) {
      // Revert optimistic update on error
      fetchSong();
      rethrow;
    }
  }
}
