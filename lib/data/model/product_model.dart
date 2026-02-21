class ProductModel {
  String? id;
  String? name;
  String? price;
  String? image;
  String? categoryId;
  String? status;
  String? createdAt;
  String? updatedAt;
  int quantity = 1;

  ProductModel(
      {this.id,
        this.name,
        this.price,
        this.image,
        this.categoryId,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.quantity = 1,

      });


  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
    categoryId = json['category_id'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    quantity = 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['image'] = image;
    data['category_id'] = categoryId;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}