import 'package:flutter/material.dart';

import '../../../model/songs/song_with_artist.dart';

class SongTile extends StatelessWidget {
  const SongTile({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.onTap,
  });

  final SongWithArtist song;
  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: onTap,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(song.artistImageUrl.toString()),
            radius: 25,
          ),
          title: Text(
            song.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            '${song.artistName} - ${song.artistGenre}',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          trailing: Text(
            isPlaying ? "Playing" : "",
            style: const TextStyle(color: Colors.amber),
          ),
        ),
      ),
    );
  }
}
