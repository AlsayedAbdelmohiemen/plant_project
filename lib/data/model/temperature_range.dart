class TemperatureRange {
  final String min;
  final String max;

  TemperatureRange({required this.min, required this.max});

  factory TemperatureRange.fromJson(Map<String, dynamic> json) => TemperatureRange(
    min: json["min"],
    max: json["max"],
  );

  Map<String, dynamic> toJson() => {
    "min": min,
    "max": max,
  };
}