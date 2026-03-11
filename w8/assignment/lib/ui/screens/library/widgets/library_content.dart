import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/theme.dart';
import '../../../widgets/song/song_tile.dart';
import '../view_model/library_view_model.dart';

class LibraryContent extends StatelessWidget {
  const LibraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the library view model
    LibraryViewModel viewModel = context.watch<LibraryViewModel>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text("Library", style: AppTextStyles.heading),
          const SizedBox(height: 50),
          Expanded(
            child: viewModel.songsState.when(
              // Loading state - show circular progress indicator
              loading: () {
                return const Center(child: CircularProgressIndicator());
              },
              // Error state - show error message
              error: (exception) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      Text('Error loading songs', style: AppTextStyles.heading),
                      const SizedBox(height: 8),
                      Text(
                        exception.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
              // Success state - show list of songs
              data: (songs) {
                if (songs.isEmpty) {
                  return const Center(child: Text('No songs found'));
                }

                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) => SongTile(
                    song: songs[index],
                    isPlaying: viewModel.isSongPlaying(songs[index]),
                    onTap: () {
                      viewModel.start(songs[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
