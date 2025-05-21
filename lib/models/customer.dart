
import 'package:hive/hive.dart';

part 'customer.g.dart';
@HiveType(typeId: 1)
class CustomerModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  DateTime? createdAt;

  CustomerModel({this.name, this.id, this.createdAt});

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'visit_date': createdAt!.toIso8601String(),
      'name': name,
    };
  }
}
