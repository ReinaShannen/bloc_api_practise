part of 'weather_bloc.dart';

abstract class WeatherEvent {}

class FetchWeatherEvent extends WeatherEvent {
  final String city;

  FetchWeatherEvent(this.city);
}
