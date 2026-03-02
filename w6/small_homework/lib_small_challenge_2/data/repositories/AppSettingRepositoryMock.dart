import '../../model/settings/app_settings.dart';
import 'AppSettingRepository.dart';

class Appsettingrepositorymock implements Appsettingrepository {
  AppSettings appSettings = AppSettings(themeColor: ThemeColor.blue);
  @override
  Future<AppSettings> load() async {
    return appSettings;
  }

  @override
  Future<void> save(AppSettings settings) async {
    appSettings = settings;
  }
}
