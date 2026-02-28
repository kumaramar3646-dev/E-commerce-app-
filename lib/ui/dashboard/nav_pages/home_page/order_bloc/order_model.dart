import '../../../../../data/model/product_model.dart';

class OrderModel {
  String? id;
  String? totalAmount;
  String? status;
  String? date;
  List<ProductModel>? products; // अगर products भी आते हैं

  OrderModel({this.id, this.totalAmount, this.status, this.date, this.products});

  OrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalAmount = json['total_amount'];
    status = json['status'];
    date = json['created_at'];
    // products = ... अगर आते हैं तो
  }
}