import 'package:fire_practice/model/artists/artist.dart';
import 'package:fire_practice/ui/screens/artist/artist_view_model/artist_view_model.dart';
import 'package:fire_practice/ui/theme/theme.dart';
import 'package:fire_practice/ui/utils/async_value.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistContent extends StatelessWidget {
  const ArtistContent({super.key});

  @override
  Widget build(BuildContext context) {
    // 1- Read the globbal song repository
    ArtistViewModel mv = context.watch<ArtistViewModel>();

    AsyncValue<List<Artist>> asyncValue = mv.artistValue;

    Widget content;
    switch (asyncValue.state) {
      case AsyncValueState.loading:
        content = Center(child: CircularProgressIndicator());
        break;
      case AsyncValueState.error:
        content = Center(
          child: Text(
            'error = ${asyncValue.error!}',
            style: TextStyle(color: Colors.red),
          ),
        );

      case AsyncValueState.success:
        List<Artist> artists = asyncValue.data!;
        content = ListView.builder(
          itemCount: artists.length,
          itemBuilder: (context, index) {
            final artist = artists[index];
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: ListTile(
                  title: Text(artist.name),
                  leading: Image.network(artist.imageUrl.toString()),
                  subtitle: Text(artist.genre),
                ),
              ),
            );
          }
        );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Text("Artist", style: AppTextStyles.heading),
          SizedBox(height: 50),

          Expanded(child: content),
        ],
      ),
    );
  }
}
