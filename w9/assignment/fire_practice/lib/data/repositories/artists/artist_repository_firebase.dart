import 'dart:convert';
import 'package:fire_practice/data/dtos/artist_dto.dart';
import 'package:http/http.dart' as http;
import 'package:fire_practice/data/repositories/artists/artist_repository.dart';
import 'package:fire_practice/model/artists/artist.dart';

class ArtistRepositoryFirebase extends ArtistRepository {
  final Uri artistUri = Uri.https(
    'week-8-practice-20451-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/week9/artists.json',
  );
  @override
  Future<List<Artist>> fetchArtists() async {
    final http.Response response = await http.get(artistUri);
    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      final decode = json.decode(response.body);
      final Map<String, dynamic> artistJson = Map<String, dynamic>.from(decode);
      List<Artist> artists = [];

      artistJson.forEach((key, value) {
        final artistJson = Map<String, dynamic>.from(value as Map);
        artists.add(ArtistDto.fromJson(key, artistJson));
      });

      return artists;
      // return songJson.map((item) => SongDto.fromJson(key, item)).toList();
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }
}
