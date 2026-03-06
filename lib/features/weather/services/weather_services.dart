import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/weather_model.dart';

class WeatherService {



//no key for Git Push
  static const String _apiKey =
  String.fromEnvironment('weather_API_KEY');

  Future<WeatherModel> fetchWeather(String city) async {

    if (city.trim().isEmpty) {
      throw Exception('Please enter a city name.');
    }

    final response = await http.get(
      Uri.https(
        'api.openweathermap.org',
        '/data/2.5/weather',
        {
          'q': city.trim(),
          'appid': _apiKey,
          'units': 'metric',
        },
      ),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(data);
    } else {
      final message = data['message'] ?? 'Failed to load weather';
      throw Exception(message);
    }
  }
}