import 'package:flutter/material.dart';
 
import 'download_controler.dart';

class DownloadTile extends StatelessWidget {
  const DownloadTile({super.key, required this.controller});

  final DownloadController controller;
 
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // File name and progress info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.ressource.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (controller.status == DownloadStatus.downloading)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${(controller.progress * 100).toStringAsFixed(1)}% completed - ${(controller.progress * controller.ressource.size).toStringAsFixed(1)} of ${controller.ressource.size} MB',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFB0C4CE),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Status icon / Progress indicator
              _buildStatusWidget(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusWidget() {
    switch (controller.status) {
      case DownloadStatus.notDownloaded:
        return GestureDetector(
          onTap: () => controller.startDownload(),
          child: const Icon(
            Icons.download,
            color: Color(0xFF054752),
            size: 28,
          ),
        );

      case DownloadStatus.downloading:
        return SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            value: controller.progress,
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF054752)),
            strokeWidth: 3,
          ),
        );

      case DownloadStatus.downloaded:
        return const Icon(
          Icons.folder,
          color: Color(0xFF054752),
          size: 28,
        );
    }
  }
}
