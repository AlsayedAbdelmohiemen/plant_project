class PredictionResult {
  final String confidence;
  final String disease;
  final String plant;
  final String treatment;

  PredictionResult({
    required this.confidence,
    required this.disease,
    required this.plant,
    required this.treatment,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    return PredictionResult(
      confidence: json['confidence'],
      disease: json['disease'],
      plant: json['plant'],
      treatment: json['treatment'],
    );
  }
}
