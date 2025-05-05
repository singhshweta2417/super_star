

class ProfileModel {
  bool? success;
  String? message;
  Data? data;

  ProfileModel({this.success, this.message, this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? username;
  String? name;
  String? mobile;
  String? email;
  String? emailVerifiedAt;
  int? parentId;
  int? roleId;
  int? revenue;
  int? status;
  String? createdAt;
  String? updatedAt;
  dynamic wallet;

  Data({
    this.id,
    this.username,
    this.name,
    this.mobile,
    this.email,
    this.emailVerifiedAt,
    this.parentId,
    this.roleId,
    this.revenue,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.wallet,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    parentId = json['parent_id'];
    roleId = json['role_id'];
    revenue = json['revenue'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    wallet = json['wallet'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['name'] = name;
    data['mobile'] = mobile;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['parent_id'] = parentId;
    data['role_id'] = roleId;
    data['revenue'] = revenue;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['wallet'] = wallet;
    return data;
  }
}
