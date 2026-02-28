// presentation/screens/orders/bloc/order_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/helper/api_helper.dart';
import '../../../../../domain/constant/app_urls.dart';
import 'order_event.dart';
import 'order_model.dart';
import 'order_state.dart';


class OrderBloc extends Bloc<OrderEvent, OrderState> {
  ApiHelper apiHelper;

  OrderBloc({required this.apiHelper}) : super(OrderInitialState()) {

    on<FetchOrdersEvent>((event, emit) async {
      emit(OrderLoadingState());

      try {
        var response = await apiHelper.postAPI(url: AppUrls.getOrder_url);

        if (response["status"] == true || response["status"] == "true") {
          List<dynamic> data = response["orders"] ?? [];
          List<OrderModel> orders = data.map((e) => OrderModel.fromJson(e)).toList();
          emit(OrderLoadedState(orders: orders));
        } else {
          emit(OrderErrorState(errorMsg: response["message"] ?? "No orders found"));
        }
      } catch (e) {
        emit(OrderErrorState(errorMsg: "Error: $e"));
      }
    });
  }
}