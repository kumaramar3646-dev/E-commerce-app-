import '../../data/model/product_model.dart';

abstract class CartEvent {}

/// API Events
class AddToCartAPIEvent extends CartEvent {
  final String productId;
  final int qty;
  AddToCartAPIEvent({required this.productId, required this.qty});
}

/// Local Cart Events
class AddToCartLocalEvent extends CartEvent {
  final ProductModel product;
  AddToCartLocalEvent({required this.product});
}

class RemoveFromCartEvent extends CartEvent {
  final String productId;
  RemoveFromCartEvent({required this.productId});
}

class IncreaseQuantityEvent extends CartEvent {
  final String productId;
  IncreaseQuantityEvent({required this.productId});
}

class DecreaseQuantityEvent extends CartEvent {
  final String productId;
  DecreaseQuantityEvent({required this.productId});
}

class ClearCartEvent extends CartEvent {}

class LoadCartEvent extends CartEvent {}