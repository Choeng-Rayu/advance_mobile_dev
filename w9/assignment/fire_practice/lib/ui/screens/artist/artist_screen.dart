import 'package:fire_practice/data/repositories/artists/artist_repository.dart';
import 'package:fire_practice/ui/screens/artist/artist_content.dart';
import 'package:fire_practice/ui/screens/artist/artist_view_model/artist_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistScreen extends StatelessWidget {
  const ArtistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArtistViewModel(
        artistRepository: context.read<ArtistRepository>()
      ),
      child: ArtistContent(),
    );
  }
}