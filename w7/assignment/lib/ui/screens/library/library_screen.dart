import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/songs/song_repository.dart';
import '../../states/player_state.dart';
import '../../states/settings_state.dart';
import 'view_model/library_view_model.dart';
import 'widgets/library_content.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Read the global song repository
    SongRepository songRepository = context.read<SongRepository>();

    // Read the global settings state
    AppSettingsState settingsState = context.read<AppSettingsState>();

    // Read the global player state
    PlayerState playerState = context.read<PlayerState>();

    // Create LibraryViewModel with required repositories and notifiers
    return ChangeNotifierProvider(
      create: (_) => LibraryViewModel(
        songRepository: songRepository,
        playerState: playerState,
        appSettingsState: settingsState,
      ),
      child: const LibraryContent(),
    );
  }
}
