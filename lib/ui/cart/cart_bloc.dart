import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/helper/api_helper.dart';
import '../../data/model/product_model.dart';
import '../../domain/constant/app_urls.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  ApiHelper apiHelper;

  List<ProductModel> cartItems = [];

  CartBloc({required this.apiHelper}) : super(CartInitialState()) {

    on<AddToCartAPIEvent>((event, emit) async {
      emit(CartLoadingState());

      try {
        var response = await apiHelper.postAPI(
            url: AppUrls.add_to_cart_url,
            mBodyParams: {
              "product_id": event.productId,
              "quantity": event.qty
            }
        );

        if (response["status"] == true || response["status"] == "true") {
          emit(CartSuccessState());
          add(LoadCartEvent());
        } else {
          emit(CartFailureState(errorMsg: "Failed to add"));
        }
      } catch (e) {
        emit(CartFailureState(errorMsg: "Error: $e"));
      }
    });

    on<AddToCartLocalEvent>((event, emit) {
      int index = findItemIndex(event.product.id!);

      if (index != -1) {

        cartItems[index].quantity++;
      } else {
        event.product.quantity = 1;
        cartItems.add(event.product);
      }

      emit(CartUpdatedState(
        cartItems: cartItems,
        totalAmount: calculateTotal(),
      ));
    });
    on<IncreaseQuantityEvent>((event, emit) {
      int index = findItemIndex(event.productId);

      if (index != -1) {
        cartItems[index].quantity++;
      }

      emit(CartUpdatedState(
        cartItems: cartItems,
        totalAmount: calculateTotal(),
      ));
    });
    on<DecreaseQuantityEvent>((event, emit) {
      int index = findItemIndex(event.productId);

      if (index != -1) {
        if (cartItems[index].quantity > 1) {
          cartItems[index].quantity--;
        } else {
          cartItems.removeAt(index);
        }
      }

      emit(CartUpdatedState(
        cartItems: cartItems,
        totalAmount: calculateTotal(),
      ));
    });
    on<RemoveFromCartEvent>((event, emit) {
      int index = findItemIndex(event.productId);

      if (index != -1) {
        cartItems.removeAt(index);
      }

      emit(CartUpdatedState(
        cartItems: cartItems,
        totalAmount: calculateTotal(),
      ));
    });

    on<ClearCartEvent>((event, emit) {
      cartItems.clear();

      emit(CartUpdatedState(
        cartItems: [],
        totalAmount: 0,
      ));
    });
    on<LoadCartEvent>((event, emit) {
      emit(CartUpdatedState(
        cartItems: cartItems,
        totalAmount: calculateTotal(),
      ));
    });
  }
  int findItemIndex(String productId) {
    for (int i = 0; i < cartItems.length; i++) {
      if (cartItems[i].id == productId) {
        return i; // Index mil gaya
      }
    }
    return -1;
  }
  double calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      double price = double.tryParse(item.price ?? '0') ?? 0;
      total = total + (price * item.quantity);
    }
    return total;
  }
}