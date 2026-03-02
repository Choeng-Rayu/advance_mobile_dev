import '../../model/settings/app_settings.dart';

abstract class Appsettingrepository {
  Future<AppSettings> load();
  Future<void> save(AppSettings appSettings);
}
