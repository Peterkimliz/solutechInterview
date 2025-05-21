
import 'package:hive/hive.dart';

part 'activity.g.dart';
@HiveType(typeId: 2)
class ActivityModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? description;
  @HiveField(2)
  DateTime? createdAt;

  ActivityModel({this.description, this.id, this.createdAt});

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'],
      description: json['description'],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt!.toIso8601String(),
      'description': description,
    };
  }
}

