import 'package:fire_practice/model/artists/artist.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists();
}
