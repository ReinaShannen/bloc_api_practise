import 'package:bloc/bloc.dart';
import '../model/weather_model.dart';
import '../repository/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<FetchWeatherEvent>((event, emit) async {
      emit(WeatherLoading());

      try {
        final weather = await weatherRepository.getWeather(event.city);

        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError(e.toString().replaceFirst('Exception: ', '')));
      }
    });
  }
}
