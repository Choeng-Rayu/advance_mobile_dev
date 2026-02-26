import 'package:flutter/widgets.dart';
// import 'package:small_homework/model/song.dart';

class PlayerState extends ChangeNotifier {
  String? _currentSong;
  String? get currentSong => _currentSong;

  void playSong(String song) {
    _currentSong = song;
    notifyListeners();
  }

  void stopSong() {
    _currentSong = null;
    notifyListeners();
  }
}
