import 'package:mongo_dart/mongo_dart.dart';

class Admin {
  ObjectId? id;
  String name;
  String email;
  String phone;
  ObjectId permissionId; // Referencia a permissions
  ObjectId addressId;    // Referencia a addresses

  Admin({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.permissionId,
    required this.addressId,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'permission_id': permissionId,
      'address_id': addressId,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      id: map['_id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      permissionId: map['permission_id'],
      addressId: map['address_id'],
    );
  }
}
