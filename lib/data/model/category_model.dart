class CategoryModel {
  final String id;
  final String name;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '1',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  // 👇 YEH OPTIONAL HAI - Add kar lein
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}