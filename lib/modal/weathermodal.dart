class WeatherData {
  final String cityName;
  final String country;
  final double temperature;
  final double windSpeed;
  final int humidity;
  final String condition;
  final double UV;
  final double pressure;
  final double realfeel;
  final List<ForecastDay> forecast;

  WeatherData({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.condition,
    required this.forecast,
    required this.UV,
    required this.pressure,
    required this.realfeel,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['location']['name'],
      country: json['location']['country'],
      temperature: json['current']['temp_c'],
      windSpeed: json['current']['wind_kph'],
      humidity: json['current']['humidity'],
      condition: json['current']['condition']['text'],
      UV: json['current']['uv'],
      pressure: json['current']['pressure_mb'],
      realfeel: json['current']['feelslike_c'],
      forecast: (json['forecast']['forecastday'] as List)
          .map((day) => ForecastDay.fromJson(day))
          .toList(),
    );
  }
}

class ForecastDay {
  final String date;
  final double maxTemp;
  final double minTemp;
  final double avgTemp;
  final String condition;

  ForecastDay({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.avgTemp,
    required this.condition,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      maxTemp: json['day']['maxtemp_c'],
      minTemp: json['day']['mintemp_c'],
      avgTemp: (json['day']['avgtemp_c']),
      condition: json['day']['condition']['text'],
    );
  }
}
