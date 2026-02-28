abstract class ProductEvent {}

class FetchAllProductEvent extends ProductEvent {}

class FetchProductsByCategoryEvent extends ProductEvent {
  final String categoryId;
  FetchProductsByCategoryEvent({required this.categoryId});
}


