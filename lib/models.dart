class WeatherInfo {
  final String main;
  final String description;
  final String icon;

  WeatherInfo({this.main, this.description, this.icon});

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final description = json['description'];
    final icon = json['icon'];
    return WeatherInfo(main: main, description: description, icon: icon);
  }
}

class TemperatureInfo {
  final num temperature;

  TemperatureInfo({this.temperature});

  factory TemperatureInfo.fromJson(Map<String, dynamic> json) {
    final temperature = json['temp'];
    return TemperatureInfo(temperature: temperature);
  }
}

class HumidityInfo {
  final num humidity;

  HumidityInfo({this.humidity});

  factory HumidityInfo.fromJson(Map<String, dynamic> json) {
    final humidity = json['humidity'];
    return HumidityInfo(humidity: humidity);
  }
}

class WindInfo {
  final num wind;

  WindInfo({this.wind});

  factory WindInfo.fromJson(Map<String, dynamic> json) {
    final wind = json['speed'];
    return WindInfo(wind: wind);
  }
}

class WeatherResponse {
  final String cityName;
  final TemperatureInfo tempInfo;
  final HumidityInfo humidInfo;
  final WindInfo windInfo;
  final WeatherInfo weatherInfo;

  String get iconUrl {
    return 'https://openweathermap.org/img/wn/${weatherInfo.icon}@4x.png';
  }

  WeatherResponse(
      {this.cityName,
      this.tempInfo,
      this.humidInfo,
      this.windInfo,
      this.weatherInfo});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final cityName = json['name'];

    final tempInfoJson = json['main'];
    final tempInfo = TemperatureInfo.fromJson(tempInfoJson);

    final humidInfoJson = json['main'];
    final humidInfo = HumidityInfo.fromJson(humidInfoJson);

    final windInfoJson = json['wind'];
    final windInfo = WindInfo.fromJson(windInfoJson);

    final weatherInfoJson = json['weather'][0];
    final weatherInfo = WeatherInfo.fromJson(weatherInfoJson);

    return WeatherResponse(
        cityName: cityName,
        tempInfo: tempInfo,
        humidInfo: humidInfo,
        windInfo: windInfo,
        weatherInfo: weatherInfo);
  }
}
