// song_repository_mock.dart

import '../../../model/songs/song.dart';
import '../../../model/async_value.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  static int _callCount = 0;

  final List<Song> _songs = [
    Song(
      id: 's1',
      title: 'Mock Song 1',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 2, seconds: 50),
    ),
    Song(
      id: 's2',
      title: 'Mock Song 2',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
    Song(
      id: 's3',
      title: 'Mock Song 3',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
    Song(
      id: 's4',
      title: 'Mock Song 4',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
    Song(
      id: 's5',
      title: 'Mock Song 5',
      artist: 'Mock Artist',
      duration: const Duration(minutes: 3, seconds: 20),
    ),
  ];

  @override
  Future<AsyncValue<List<Song>>> fetchSongs() async {
    // Increment call count
    _callCount++;

    // Simulate a delay of 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Simulate an error every 2 tries (on even call counts)
    if (_callCount % 2 == 0) {
      return AsyncValue.error(
        Exception('Failed to fetch songs from the database'),
      );
    }

    // Return success with songs data
    return AsyncValue.data(_songs);
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    // - Simulate a delay of 3 seconds.

    // - After the delay : Find the song of given id in the list of songs and return it

    // - If not found : Throw an error with the message "no song found for id 25 in the database"

    return Future.delayed(Duration.zero); // TO CHANGE !
  }
}
