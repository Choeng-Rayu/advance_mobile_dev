import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_color_provider.dart';
import '../../theme/theme.dart';
import 'widgets/download_controler.dart';
import 'widgets/download_tile.dart';


class DownloadsScreen extends StatelessWidget {
  // Create the list of fake ressources
  final List<Ressource> ressources = [
    Ressource(name: "image1.png", size: 120),
    Ressource(name: "image1.png", size: 500),
    Ressource(name: "image3.png", size: 12000),
  ];

  final List<DownloadController> controllers = [];

  DownloadsScreen({super.key}) {
    // Create a controllers for each ressource
    for (Ressource ressource in ressources) {
      controllers.add(DownloadController(ressource));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to theme color changes
    return Consumer<ThemeColorProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          color: themeProvider.backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text(
                "Downloads",
                style: AppTextStyles.heading.copyWith(
                  color: themeProvider.color,
                ),
              ),

              SizedBox(height: 50),

              // Display all Download tiles
              Expanded(
                child: ListView.builder(
                  itemCount: controllers.length,
                  itemBuilder: (context, index) {
                    return DownloadTile(controller: controllers[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
