
class VisitModel {
  final int ?id;
  final int? customerId;
  final DateTime? visitDate;
  final String? status;
  final String? location;
  final String? notes;
  final List<String>? activitiesDone;
  final DateTime? createdAt;

  VisitModel({
    this.id,
    this.customerId,
    this.visitDate,
    this.status,
    this.location,
    this.notes,
    this.activitiesDone,
    this.createdAt,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      id: json['id'],
      customerId: json['customer_id'],
      visitDate: DateTime.parse(json['visit_date']),
      status: json['status']??"",
      location: json['location']??"",
      notes: json['notes'] ?? "",
      activitiesDone: List<String>.from(json['activities_done'] ?? []),
      createdAt:json['created_at']==null?null: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'visit_date': visitDate!.toIso8601String(),
      'status': status,
      'location': location,
      'notes': notes,
      'activities_done': activitiesDone,
    };
  }
}