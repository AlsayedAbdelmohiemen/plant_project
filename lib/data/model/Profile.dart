class Profile {
  String? message;
  bool? success;
  Data? data;

  Profile({this.message, this.success, this.data});

  Profile.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? userName;
  String? email;
  String? password;
  String? role;
  bool? isVerified;
  bool? otpVerified;
  List<String>? plants;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data({
    this.sId,
    this.userName,
    this.email,
    this.password,
    this.role,
    this.isVerified,
    this.otpVerified,
    this.plants,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['userName'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
    isVerified = json['isVerified'];
    otpVerified = json['otpVerified'];
    plants = List<String>.from(json['plants'] ?? []);
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'userName': userName,
      'email': email,
      'password': password,
      'role': role,
      'isVerified': isVerified,
      'otpVerified': otpVerified,
      'plants': plants,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': iV,
    };
  }

  /// ✅ Only include fields you want to update
  Map<String, dynamic> toUpdateJson() {
    return {
      if (userName != null) 'userName': userName,
      if (email != null) 'email': email,
    };
  }
}
