import 'package:flutter/widgets.dart';

import '../../data/repositories/AppSettingRepository.dart';
import '../../model/settings/app_settings.dart';

class AppSettingsState extends ChangeNotifier {
  AppSettings? _appSettings;
  Appsettingrepository repo;

  AppSettingsState({required this.repo});

  Future<void> init() async {
    // Might be used to load data from repository
    repo.load();
    notifyListeners();
  }

  ThemeColor get theme => _appSettings?.themeColor ?? ThemeColor.blue;

  Future<void> changeTheme(ThemeColor themeColor) async {
    if (_appSettings == null) return;
    _appSettings = _appSettings!.copyWith(themeColor: themeColor);

    notifyListeners();
  }
}
