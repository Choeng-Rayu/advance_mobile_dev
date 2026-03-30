import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final String baseUrl = 'week9-firebase-8740e-default-rtdb.asia-southeast1.firebasedatabase.app';
  
  final Uri songsUri = Uri.https(
    'week9-firebase-8740e-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/songs.json',
  );

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}
  
  @override
  Future<void> toggleLikeSong(String songId, bool currentLikedState) async {
    final Uri likeUri = Uri.https(
      baseUrl,
      '/songs/$songId/isLiked.json',
    );
    
    // Toggle the like state
    final bool newLikedState = !currentLikedState;
    
    // Use PUT to update the isLiked field
    final http.Response response = await http.put(
      likeUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(newLikedState),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle like: ${response.statusCode} - ${response.body}');
    }
  }
}
