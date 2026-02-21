import 'package:ecommerce_app/ui/dashboard/nav_pages/home_page/bloc/product_event.dart';
import 'package:ecommerce_app/ui/dashboard/nav_pages/home_page/bloc/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/helper/api_helper.dart';
import '../../../../../data/model/product_model.dart';
import '../../../../../domain/constant/app_urls.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ApiHelper apiHelper;

  ProductBloc({required this.apiHelper}) : super(ProductInitialState()) {
    on<FetchAllProductEvent>((event, emit) async{
      emit(ProductLoadingState());

      try {

        dynamic mData = await apiHelper.postAPI(url: AppUrls.product_url);
        if(mData["status"]){
          List<ProductModel> mProducts = [];
          for(Map<String, dynamic> eachMap in mData["data"]){
            mProducts.add(ProductModel.fromJson(eachMap));
          }
          emit(ProductLoadedState(products: mProducts));
        } else {
          emit(ProductErrorState(errorMsg: mData["message"]));
        }

      } catch (e) {
        emit(ProductErrorState(errorMsg: e.toString()));
      }
    });
  }
}