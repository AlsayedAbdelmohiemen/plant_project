
class ImageData {
  final String secureUrl;
  final String publicId;

  ImageData({required this.secureUrl, required this.publicId});

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
    secureUrl: json["secure_url"],
    publicId: json["public_id"],
  );

  Map<String, dynamic> toJson() => {
    "secure_url": secureUrl,
    "public_id": publicId,
  };
}