abstract class WeatherListener {
  void onWeatherChange(int newTemperature);
}

class WeatherStation {
  int temperature;
  final List<WeatherListener> _listener = [];

  WeatherStation({this.temperature = 0});

  void addListener(WeatherListener listener) {
    _listener.add(listener);
  }

  void setTemperature(int newTemperature) {
    if (newTemperature != temperature) {
      temperature = newTemperature;
      _notifyListener();
    }
  }

  void _notifyListener() {
    for (WeatherListener listener in _listener) {
      listener.onWeatherChange(temperature);
    }
  }
}

class WebApp extends WeatherListener {
  WebApp(this.myWeatherStation) {
    myWeatherStation.addListener(this);
  }

  final WeatherStation myWeatherStation;

  @override
  void onWeatherChange(int newTemperature) {
    print("<h1> The new eather is ${newTemperature.toString()} </h1>");
  }
}

class MobileApp extends WeatherListener {
  MobileApp(this.myWeatherStation) {
    myWeatherStation.addListener(this);
  }

  final WeatherStation myWeatherStation;

  @override
  void onWeatherChange(int newTemperature) {
    print(
      "<scafold> The new eather is ${newTemperature.toString()} </scafold>",
    );
  }
}

void main() {
  WeatherStation myWeatherStation = new WeatherStation();

  WebApp myWebApp = WebApp(myWeatherStation);
  MobileApp mobileApp = MobileApp(myWeatherStation);

  // CHange the temperate to 10 degree
  myWeatherStation.setTemperature(10);
}
