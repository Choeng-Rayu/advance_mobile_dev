import 'package:fire_practice/model/artists/artist.dart';

class ArtistDto {
  static const String nameKey = 'name';
  static const String genreKey = 'genre';
  static const String imageKey = 'imageUrl';

  static Artist fromJson(String id, Map<String, dynamic> json) {
    return Artist(
      id: id,
      genre: json[genreKey],
      name: json[nameKey],
      imageUrl: Uri.parse(imageKey),
    );
  }

  Map<String, dynamic> toJson(Artist artist) {
    return {
      nameKey: artist.name,
      genreKey: artist.genre,
      imageKey: artist.imageUrl.toString(),
    };
  }
}
