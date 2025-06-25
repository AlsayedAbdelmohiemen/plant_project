import 'package:final2/data/model/plants.dart';
class MainPlants {
  final bool success;
  final String message;
  final int count;
  final List<PlantsDetail> data;

  MainPlants({
    required this.success,
    required this.message,
    required this.count,
    required this.data,
  });

  // Convert JSON to Model
  factory MainPlants.fromJson(Map<String, dynamic> json) => MainPlants(
    success: json["success"],
    message: json["message"],
    count: json["count"],
    data: List<PlantsDetail>.from(json["data"].map((x) => PlantsDetail.fromJson(x))),
  );

  // Convert Model to JSON
  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "count": count,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}
