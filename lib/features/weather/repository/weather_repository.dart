import '../model/weather_model.dart';
import '../services/weather_services.dart';

class WeatherRepository {
  final WeatherService weatherService;

  WeatherRepository(this.weatherService);

  Future<WeatherModel> getWeather(String city) async {
    return weatherService.fetchWeather(city);
  }
}
