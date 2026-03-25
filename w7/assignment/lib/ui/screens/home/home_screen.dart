import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/repositories/songs/song_repository.dart';
import '../../../data/repositories/user_history/user_history_repository.dart';
import '../../states/player_state.dart';
import 'home_content.dart';
import 'home_view_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeViewModel(
            songRepository: context.read<SongRepository>(),
            userHistoryRepository: context.read<UserHistoryRepository>(),
            playerState: context.read<PlayerState>(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          elevation: 0,
        ),
        body: const HomeContent(),
      ),
    );
  }
}
