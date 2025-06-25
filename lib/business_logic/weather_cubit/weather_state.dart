// lib/bloc/weather_state.dart


import '../../data/model/weather_model.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherModel weather;
  WeatherLoaded({required this.weather});
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError({required this.message});
}
