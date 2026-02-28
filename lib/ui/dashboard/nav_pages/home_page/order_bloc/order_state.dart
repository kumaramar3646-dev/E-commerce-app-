

import 'order_model.dart';

abstract class OrderState {}

class OrderInitialState extends OrderState {}
class OrderLoadingState extends OrderState {}
class OrderLoadedState extends OrderState {
  final List<OrderModel> orders;
  OrderLoadedState({required this.orders});
}
class OrderErrorState extends OrderState {
  final String errorMsg;
  OrderErrorState({required this.errorMsg});
}