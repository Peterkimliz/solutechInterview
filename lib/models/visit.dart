import 'package:hive/hive.dart';

part 'visit.g.dart';

@HiveType(typeId: 0)
class VisitModel extends HiveObject {
  @HiveField(0)
  int? id; // null for unsynced visits

  @HiveField(1)
  int? customerId;

  @HiveField(2)
  String? visitDate;

  @HiveField(3)
  String? status;

  @HiveField(4)
  String? location;

  @HiveField(5)
  String? notes;

  @HiveField(6)
  List<String> activitiesDone;

  @HiveField(7)
  bool isSynced;

  VisitModel({
    this.id,
    this.customerId,
    this.visitDate,
    this.status,
    this.location,
    this.notes,
    List<String>? activitiesDone,
    this.isSynced = false,
  }) : activitiesDone = activitiesDone ?? [];

  Map<String, dynamic> toJson() => {
    "customer_id": customerId,
    "visit_date": visitDate,
    "status": status,
    "location": location,
    "notes": notes,
    "activities_done": activitiesDone,
  };

  factory VisitModel.fromJson(Map<String, dynamic> json) => VisitModel(
    id: json['id'],
    customerId: json['customer_id'],
    visitDate: json['visit_date'] == null ? null : json['visit_date'],
    status: json['status'],
    location: json['location'] ?? "",
    notes: json['notes'] ?? "",
    activitiesDone: json['activities_done'] == null
        ? []
        : List<String>.from(json['activities_done']),
    isSynced: true,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is VisitModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
