abstract class UserHistoryRepository {
  /// Get the list of recently played song IDs
  List<String> fetchRecentSongIds();

  /// Add a song ID to the history
  void addToHistory(String songId);
}
