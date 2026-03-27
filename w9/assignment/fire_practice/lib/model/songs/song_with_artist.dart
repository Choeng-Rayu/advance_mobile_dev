import '../artists/artist.dart';
import 'song.dart';

class SongWithArtist {
  final String id;
  final String title;
  final Duration duration;
  final Uri songImageUrl;
  final String artistId;
  final String artistName;
  final String artistGenre;
  final Uri artistImageUrl;

  SongWithArtist({
    required this.id,
    required this.title,
    required this.duration,
    required this.songImageUrl,
    required this.artistId,
    required this.artistName,
    required this.artistGenre,
    required this.artistImageUrl,
  });

  // Factory constructor to create SongWithArtist from Song and Artist
  factory SongWithArtist.fromSongAndArtist(Song song, Artist artist) {
    return SongWithArtist(
      id: song.id,
      title: song.title,
      duration: song.duration,
      songImageUrl: song.imageUrl,
      artistId: artist.id,
      artistName: artist.name,
      artistGenre: artist.genre,
      artistImageUrl: artist.imageUrl,
    );
  }

  @override
  String toString() {
    return 'SongWithArtist(id: $id, title: $title, artistName: $artistName, artistGenre: $artistGenre, duration: $duration)';
  }
}
