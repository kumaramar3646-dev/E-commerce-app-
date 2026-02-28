import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/product_model.dart';
import '../../../domain/constant/app_routes.dart';
import '../../cart/cart_bloc.dart';
import '../../cart/cart_event.dart';


class ProductDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final type = args["type"]; // "category", "all", or "product"

    // Single product detail
    if (type == "product") {
      final product = args["product"] as ProductModel;
      return _buildProductDetail(context, product);
    }

    // Product list (category or all)
    final products = args["products"] as List<ProductModel>;
    final categoryName = args["categoryName"] as String;

    return _buildProductList(context, products, categoryName);
  }

  // 👉 SINGLE PRODUCT DETAIL
  Widget _buildProductDetail(BuildContext context, ProductModel product) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name ?? "Product Detail"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              product.image ?? "",
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? "",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "₹ ${product.price}",
                    style: TextStyle(fontSize: 20, color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Category: ${product.categoryId == "1" ? "Android" : "Lenovo"}",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CartBloc>().add(AddToCartLocalEvent(product: product));
                        context.read<CartBloc>().add(AddToCartAPIEvent(productId: product.id!, qty: 1));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Added to cart")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrangeAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Add to Cart", style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 👉 PRODUCT LIST (Category or All)
  Widget _buildProductList(BuildContext context, List<ProductModel> products, String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: products.isEmpty
          ? Center(child: Text("No products found"))
          : GridView.builder(
        padding: EdgeInsets.all(11),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 11,
          crossAxisSpacing: 11,
          childAspectRatio: 11 / 12,
        ),
        itemBuilder: (_, index) {
          final product = products[index];
          return InkWell(
            onTap: () {
              // 👉 Product tap - detail page
              Navigator.pushNamed(
                context,
                AppRoutes.route_product_details_page,
                arguments: {
                  "type": "product",
                  "product": product,
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF0E8F2),
                borderRadius: BorderRadius.circular(31),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          product.image ?? "",
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(height: 11),
                        Text(
                          product.name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "₹ ${product.price}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepOrangeAccent),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.deepOrangeAccent,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(21),
                          bottomLeft: Radius.circular(11),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          context.read<CartBloc>().add(AddToCartLocalEvent(product: product));
                          context.read<CartBloc>().add(AddToCartAPIEvent(productId: product.id!, qty: 1));
                        },
                        icon: Icon(Icons.add_shopping_cart, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
