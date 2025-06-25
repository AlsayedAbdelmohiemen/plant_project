import 'package:final2/data/model/images.dart';
import 'package:final2/data/model/temperature_range.dart';
class PlantsDetail {
  final String id;
  final String name;
  final String scientificName;
  final String category;
  final String origin;
  final String description;
  final String wateringFrequency;
  final String soilType;
  final TemperatureRange temperatureRange;
  final ImageData image;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  PlantsDetail({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.category,
    required this.origin,
    required this.description,
    required this.wateringFrequency,
    required this.soilType,
    required this.temperatureRange,
    required this.image,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert JSON to Model
  factory PlantsDetail.fromJson(Map<String, dynamic> json) => PlantsDetail(
    id: json["_id"],
    name: json["name"],
    scientificName: json["scientificName"],
    category: json["category"],
    origin: json["origin"],
    description: json["description"],
    wateringFrequency: json["wateringFrequency"],
    soilType: json["soilType"],
    temperatureRange: TemperatureRange.fromJson(json["temperatureRange"]),
    image: ImageData.fromJson(json["Image"]),
    createdBy: json["ceratedBy"], // Looks like a typo in the JSON, should be "createdBy"
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  // Convert Model to JSON
  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "scientificName": scientificName,
    "category": category,
    "origin": origin,
    "description": description,
    "wateringFrequency": wateringFrequency,
    "soilType": soilType,
    "temperatureRange": temperatureRange.toJson(),
    "Image": image.toJson(),
    "ceratedBy": createdBy,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}