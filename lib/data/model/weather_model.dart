class WeatherModel {
  final String city;
  final String country;

  final String description;
  final double temperature;
  final double minTemperature;
  final double maxTemperature;
  final double feelsLike;
  final int humidity;

  WeatherModel({
    required this.city,
    required this.country,
    required this.description,
    required this.temperature,
    required this.minTemperature,
    required this.maxTemperature,
    required this.feelsLike,
    required this.humidity,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['location']['city'],
      country: json['location']['country'],
      description: json['weather']['description'],
      temperature: json['weather']['temperature'],
      minTemperature: json['weather']['minTemperature'],
      maxTemperature: json['weather']['maxTemperature'],
      feelsLike: json['weather']['feelsLike'],
      humidity: json['weather']['humidity'],
    );
  }
}
