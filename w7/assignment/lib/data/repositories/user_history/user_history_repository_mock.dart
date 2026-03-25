import 'user_history_repository.dart';

class UserHistoryRepositoryMock implements UserHistoryRepository {
  final List<String> _history = ['101', '102', '103'];

  @override
  List<String> fetchRecentSongIds() {
    return _history;
  }

  @override
  void addToHistory(String songId) {
    _history.remove(songId);
    _history.insert(0, songId);
  }
}
