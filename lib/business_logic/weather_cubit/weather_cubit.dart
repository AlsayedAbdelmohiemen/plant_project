
import 'package:final2/data/model/weather_model.dart';
import 'package:final2/presenatation/weather/weather_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presenatation/auth/Auth/sharedPrefrence/shared_pref.dart';
import 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService weatherService;

  WeatherCubit({required WeatherService weatherService})
      : weatherService = weatherService,
        super(WeatherInitial());

  Future<void> fetchWeather() async {
    emit(WeatherLoading());

    final token = await SharedPreference.getToken();
    if (token == null) {
      if (!isClosed) {
        emit(WeatherError(message: 'Please log in first.'));
      }
      return;
    }

    final WeatherModel? result =
    await weatherService.getWeatherByIP(token: token);
    if (!isClosed) {
      if (result != null) {
        emit(WeatherLoaded(weather: result));
      } else {
        emit(WeatherError(message: 'Failed to fetch weather data.'));
      }
    }
  }
}
