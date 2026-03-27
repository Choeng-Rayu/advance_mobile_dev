import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = Uri.https(
    'week-8-practice-20451-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/week9/songs.json',
  );

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      final decode = json.decode(response.body);
      final Map<String, dynamic> songJson = Map<String, dynamic>.from(decode);
      List<Song> songs = [];

      songJson.forEach((key, value) {
        final songJson = Map<String, dynamic>.from(value as Map);
        songs.add(SongDto.fromJson(key, songJson));
      });

      return songs;

      // return songJson.map((item) => SongDto.fromJson(key, item)).toList();
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    final Uri songUri = Uri.https(
      'week-8-practice-20451-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/week9/songs/$id.json',
    );

    final http.Response response = await http.get(songUri);

    if (response.statusCode == 200) {
      final decode = json.decode(response.body);
      if (decode == null) {
        return null;
      }
      final Map<String, dynamic> songJson = Map<String, dynamic>.from(decode);
      return SongDto.fromJson(id, songJson);
    } else {
      throw Exception('Failed to load song with id: $id');
    }
  }
}
