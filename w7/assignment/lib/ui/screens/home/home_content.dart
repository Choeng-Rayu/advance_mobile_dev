import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/songs/song.dart';
import 'home_view_model.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recent Songs Section
            _buildSectionTitle('Your recent songs'),
            const SizedBox(height: 12),
            Consumer<HomeViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.recentSongs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No recent songs yet'),
                  );
                }

                return Column(
                  children: viewModel.recentSongs
                      .map((song) => _buildSongTile(
                            context,
                            song,
                            isPlaying: viewModel.currentSong?.id == song.id,
                          ))
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 32),

            // Recommended Songs Section
            _buildSectionTitle('You might also like'),
            const SizedBox(height: 12),
            Consumer<HomeViewModel>(
              builder: (context, viewModel, _) {
                if (viewModel.recommendedSongs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No recommendations yet'),
                  );
                }

                return Column(
                  children: viewModel.recommendedSongs
                      .map((song) => _buildSongTile(
                            context,
                            song,
                            isPlaying: viewModel.currentSong?.id == song.id,
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildSongTile(BuildContext context, Song song,
      {required bool isPlaying}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  song.artist,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (isPlaying)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.pink[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'playing',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.pink,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            GestureDetector(
              onTap: () {
                context.read<HomeViewModel>().playSong(song);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'STOP',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
