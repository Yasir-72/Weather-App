import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/modal/weathermodal.dart';

class WeatherServices {
  final String _apiKey =
      '09b96f166b2c48aa89a62747250201'; // Replace with your actual API key

  // Fetch weather data based on city name
  Future<WeatherData?> fetchWeather(String cityName) async {
    final Uri uri = Uri.https(
      'api.weatherapi.com',
      '/v1/forecast.json',
      {
        'key': _apiKey,
        'q': cityName,
        'days': '7',
      },
    );

    try {
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        return WeatherData.fromJson(json);
      } else if (response.statusCode == 404) {
        throw Exception('City not found: $cityName');
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      return null; // Return null if there's an error
    }
  }

  // Fetch weather data based on geographic coordinates
  Future<WeatherData?> fetchWeatherByCoordinates(
      double latitude, double longitude) async {
    final Uri uri = Uri.https(
      'api.weatherapi.com',
      '/v1/forecast.json',
      {
        'key': _apiKey,
        'q': '$latitude,$longitude',
        'days': '7',
      },
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        return WeatherData.fromJson(json);
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching weather data by coordinates: $e');
      return null;
    }
  }
}
