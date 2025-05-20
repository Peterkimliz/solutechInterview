class Customer {
  int? id;
  String? name;
  DateTime? createdAt;

  Customer({this.name, this.id, this.createdAt});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
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
