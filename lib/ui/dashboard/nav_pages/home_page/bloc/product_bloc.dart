import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../data/helper/api_helper.dart';
import '../../../../../data/model/product_model.dart';
import '../../../../../domain/constant/app_urls.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ApiHelper apiHelper;
  List<ProductModel> allProducts = [];

  ProductBloc({required this.apiHelper}) : super(ProductInitialState()) {

    on<FetchAllProductEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        dynamic mData = await apiHelper.postAPI(url: AppUrls.product_url);
        if (mData["status"]) {
          List<ProductModel> mProducts = [];
          for (Map<String, dynamic> eachMap in mData["data"]) {
            mProducts.add(ProductModel.fromJson(eachMap));
          }
          allProducts = mProducts;
          emit(ProductLoadedState(products: mProducts));
        } else {
          emit(ProductErrorState(errorMsg: mData["message"]));
        }
      } catch (e) {
        emit(ProductErrorState(errorMsg: e.toString()));
      }
    });

    on<FetchProductsByCategoryEvent>((event, emit) async {
      emit(ProductLoadingState());
      try {
        List<ProductModel> filteredProducts = allProducts.where((product) {
          return product.categoryId == event.categoryId;
        }).toList();
        emit(ProductLoadedState(products: filteredProducts));
      } catch (e) {
        emit(ProductErrorState(errorMsg: e.toString()));
      }
    });
  }
}









