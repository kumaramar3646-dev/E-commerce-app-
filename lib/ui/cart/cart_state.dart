import '../../data/model/product_model.dart';

abstract class CartState {}

class CartInitialState extends CartState {}

/// API States
class CartLoadingState extends CartState {}
class CartSuccessState extends CartState {}
class CartFailureState extends CartState {
  String errorMsg;
  CartFailureState({required this.errorMsg});
}

/// Local Cart State
class CartUpdatedState extends CartState {
  final List<ProductModel> cartItems;
  final double totalAmount;
  CartUpdatedState({required this.cartItems, required this.totalAmount});
}

/// Order States
class OrderPlacedSuccessState extends CartState {}
class OrdersUpdatedState extends CartState {
  final List<Map<String, dynamic>> orders;
  OrdersUpdatedState({required this.orders});
}




