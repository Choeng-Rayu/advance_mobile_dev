import "../services/ride_prefs_service.dart";

abstract class RidePreferenceListener {
  void onRideChange(int newRide);
}

class RidePreferenceService {
  int listRides;
  final List<RidePreferenceListener> _listener = [];

  RidePreferenceService({this.listRides = 0});

  void addListener(RidePreferenceListener listener) {
    _listener.add(listener);
  }

  void setRides(int newRides) {
    if (newRides != listRides) {
      listRides = newRides;
      _notifyListener();
    }
  }

  void _notifyListener() {
    for (RidePreferenceListener listener in _listener) {
      listener.onRideChange(listRides);
    }
  }
}

class WebApp extends RidePreferenceListener {
  WebApp(this.listRides) {
    listRides.addListener(this);
  }

  final RidePreferenceService listRides;

  @override
  void onRideChange(int newRide) {
    print("<h1> The new eather is ${newRide.toString()} </h1>");
  }
}

class MobileApp extends RidePreferenceListener {
  MobileApp(this.listRides) {
    listRides.addListener(this);
  }

  final RidePreferenceService listRides;

  @override
  void onRideChange(int newRide) {
    print(
      "<scafold> The new rides is change to ${newRide.toString()} </scafold>",
    );
  }
}

void main() {
  RidePreferenceService newRide = RidePreferenceService();

  WebApp myWebApp = WebApp(newRide);
  MobileApp mobileApp = MobileApp(newRide);

  // CHange the rides  to 13 rides.
  newRide.setRides(13);
}
