class ImageProfile {
  ImageProfile({
    required this.message,
    required this.success,
    required this.data,
  });

  final String? message;
  final bool? success;
  final Data? data;

  factory ImageProfile.fromJson(Map<String, dynamic> json){
    return ImageProfile(
      message: json["message"],
      success: json["success"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.image,
    required this.id,
    required this.userName,
    required this.email,
    required this.password,
    required this.role,
    required this.isVerified,
    required this.otpVerified,
    required this.plants,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final Image? image;
  final String? id;
  final String? userName;
  final String? email;
  final String? password;
  final String? role;
  final bool? isVerified;
  final bool? otpVerified;
  final List<dynamic> plants;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      image: json["image"] == null ? null : Image.fromJson(json["image"]),
      id: json["_id"],
      userName: json["userName"],
      email: json["email"],
      password: json["password"],
      role: json["role"],
      isVerified: json["isVerified"],
      otpVerified: json["otpVerified"],
      plants: json["plants"] == null ? [] : List<dynamic>.from(json["plants"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

}

class Image {
  Image({
    required this.secureUrl,
    required this.publicId,
  });

  final String? secureUrl;
  final String? publicId;

  factory Image.fromJson(Map<String, dynamic> json){
    return Image(
      secureUrl: json["secure_url"],
      publicId: json["public_id"],
    );
  }

}
