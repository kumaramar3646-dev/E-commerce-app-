import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/product_model.dart';
import '../../../../domain/constant/app_routes.dart';
import '../../../cart/cart_bloc.dart';
import '../../../cart/cart_event.dart';
import '../../../cart/cart_state.dart';
import 'bloc/product_bloc.dart';
import 'bloc/product_event.dart';
import 'bloc/product_state.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currBannerPos = 0;

  // STATIC CATEGORIES
  List<Map<String, dynamic>> categories = [
    {"id": "1", "name": "vivo Y20"},
    {"id": "2", "name": "oppo"},
  ];

  List<String> bannerUrls = [
    "https://img.freepik.com/premium-vector/new-laptop-sale-promotion-social-facebook-cover-banner_252779-424.jpg",
    "https://img.freepik.com/premium-psd/biggest-sale-banner_1054968-2308.jpg",
  ];

  List<List<Color>> colorLists = [
    [Colors.black, Colors.blue,Colors.black, Colors.blue, Colors.deepOrangeAccent,Colors.blue, Colors.deepOrangeAccent, Colors.brown],
    [Colors.black, Colors.grey, Colors.redAccent, Colors.teal],
    [Colors.black, Colors.greenAccent, Colors.purple, Colors.blueGrey],
    [Colors.blue, Colors.orange, Colors.black, Colors.pinkAccent],
  ];

  void _addToCart(ProductModel product) {
    context.read<CartBloc>().add(AddToCartLocalEvent(product: product));
    context.read<CartBloc>().add(AddToCartAPIEvent(productId: product.id!, qty: 1));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.name} added to cart"),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.deepOrangeAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: "VIEW CART",
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.route_cart_page);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchAllProductEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 70),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: Color(0xffF0E8F2), shape: BoxShape.circle),
                    child: Center(
                        child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, AppRoutes.route_order_history_page);
                            },
                            child: Icon(Icons.menu, color: Colors.black))),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: Color(0xffF0E8F2), shape: BoxShape.circle),
                    child: Center(child: Icon(Icons.notifications_none_outlined, color: Colors.black)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 11),
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Color(0xffF0E8F2),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(51), borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            SizedBox(height: 11),
            // Banner
            StatefulBuilder(
              builder: (context, ss) {
                return SizedBox(
                  height: 220,
                  child: Stack(
                    children: [
                      CarouselSlider(
                        items: bannerUrls.map((e) {
                          return Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(21),
                              child: Image.network(e, fit: BoxFit.cover, width: double.infinity),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 2),
                          height: 220,
                          onPageChanged: (index, _) {
                            currBannerPos = index;
                            ss(() {});
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 21,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DotsIndicator(
                            dotsCount: bannerUrls.length,
                            position: currBannerPos.toDouble(),
                            mainAxisAlignment: MainAxisAlignment.center,
                            decorator: DotsDecorator(
                              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(51)),
                              activeColor: Colors.black,
                              color: Colors.transparent,
                              activeSize: Size(14, 7),
                              spacing: EdgeInsets.symmetric(horizontal: 2),
                              size: Size(7, 7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(51), side: BorderSide()),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 11),
            // Categories - Product image से लो
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is! ProductLoadedState) {
                  return SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (_, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 11),
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xffF0E8F2)),
                              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            ),
                            SizedBox(height: 5),
                            Text(categories[index]["name"]),
                          ],
                        );
                      },
                    ),
                  );
                }

                final products = (state as ProductLoadedState).products;


                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (_, index) {
                      final category = categories[index];
                      final categoryProduct = products.firstWhere(
                            (p) => p.categoryId == category["id"],
                        orElse: () => ProductModel(),
                      );
                      final imageUrl = categoryProduct.image ?? "https://via.placeholder.com/70";

                      return InkWell(
                        onTap: () {
                          // 👉 CATEGORY TAP - product_details_page पर जाओ
                          Navigator.pushNamed(
                            context,
                            AppRoutes.route_product_details_page,
                            arguments: {
                              "type": "category",
                              "categoryId": category["id"],
                              "categoryName": category["name"],
                              "products": products.where((p) => p.categoryId == category["id"]).toList(),
                            },
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 11),
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(category["name"]),
                          ],
                        ),
                      );
                    },
                  ),
                );

                /*return SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (_, index) {
                      final category = categories[index];
                      final categoryProduct = products.firstWhere(
                            (p) => p.categoryId == category["id"],
                        orElse: () => ProductModel(),
                      );
                      final imageUrl = categoryProduct.image ?? "https://via.placeholder.com/70";

                      return InkWell(
                        onTap: () {
                          // 👉 CATEGORY TAP - Filter products
                          context.read<ProductBloc>().add(FetchProductsByCategoryEvent(categoryId: category["id"]));
                        },
                        /// ===
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 11),
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(category["name"]),
                          ],
                        ),
                      );
                    },
                  ),
                );*/
              },
            ),
            SizedBox(height: 11),
            // Title & See All

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Special For You", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      // 👉 SEE ALL TAP - product_details_page पर जाओ
                      final allProducts = (context.read<ProductBloc>().state as ProductLoadedState).products;
                      Navigator.pushNamed(
                        context,
                        AppRoutes.route_product_details_page,
                        arguments: {
                          "type": "all",
                          "categoryName": "All Products",
                          "products": allProducts,
                        },
                      );
                    },
                    child: Text("See all", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                ],
              ),
            ),

            /*Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Special For You", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      // 👉 SEE ALL TAP - All products
                      context.read<ProductBloc>().add(FetchAllProductEvent());
                    },
                    child: Text("See all", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                ],
              ),
            ),*/
            ///===
            SizedBox(height: 11),
            // Products Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is ProductErrorState) {
                    return Center(child: Text(state.errorMsg));
                  }

                  if (state is ProductLoadedState) {
                    if (state.products.isEmpty) {
                      return Center(child: Text("No products found"));
                    }

                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: state.products.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 11,
                        crossAxisSpacing: 11,
                        childAspectRatio: 11 / 12,
                      ),
                      itemBuilder: (_, index) {
                        final product = state.products[index];
                        final colors = colorLists[index % colorLists.length];

                        return InkWell(
                          onTap: () {
                            // 👉 PRODUCT TAP - Detail page (पहले जैसा)
                            Navigator.pushNamed(
                              context,
                              AppRoutes.route_detail_page,
                              arguments: product,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(color: Color(0xffF0E8F2), borderRadius: BorderRadius.circular(31)),
                            child: Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.network(product.image ?? "", width: 100, height: 100),
                                        SizedBox(height: 11),
                                        Text(product.name ?? "", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 11),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("₹ ${product.price}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(
                                                colors.length > 4 ? 4 : colors.length,
                                                    (childIndex) {
                                                  if (colors.length > 4 && childIndex == 3) {
                                                    return Container(width: 22, height: 22, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.transparent, border: Border.all(color: Colors.grey)), child: Center(child: Text("+${(colors.length - 3)}", style: TextStyle(color: Colors.grey, fontSize: 10))));
                                                  }
                                                  if (childIndex == 0) {
                                                    return SizedBox(width: 22, height: 22, child: Stack(children: [Container(width: 22, height: 22, decoration: BoxDecoration(border: Border.all(color: colors[childIndex]), shape: BoxShape.circle)), Center(child: Container(margin: EdgeInsets.all(3), width: 16, height: 16, decoration: BoxDecoration(color: colors[childIndex], shape: BoxShape.circle)))]));
                                                  }
                                                  return Container(margin: EdgeInsets.all(3), width: 16, height: 16, decoration: BoxDecoration(color: colors[childIndex], shape: BoxShape.circle));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(color: Colors.deepOrangeAccent, borderRadius: BorderRadius.only(topRight: Radius.circular(21), bottomLeft: Radius.circular(11))),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () => _addToCart(product),
                                        icon: Icon(Icons.add_shopping_cart, color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}




/*
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/product_model.dart';
import '../../../../domain/constant/app_routes.dart';
import '../../../cart/cart_bloc.dart';
import '../../../cart/cart_event.dart';
import '../../../cart/cart_state.dart';
import 'bloc/product_bloc.dart';
import 'bloc/product_event.dart';
import 'bloc/product_state.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currBannerPos = 0;

  // STATIC CATEGORIES - API नहीं
  List<Map<String, dynamic>> categories = [
    {"id": "1", "name": "Android", "image": "https://cdn-icons-png.flaticon.com/512/888/888839.png"},
    {"id": "2", "name": "Lenovo", "image": "https://cdn-icons-png.flaticon.com/512/888/888839.png"},
  ];

  List<String> bannerUrls = [
    "https://img.freepik.com/premium-vector/new-laptop-sale-promotion-social-facebook-cover-banner_252779-424.jpg",
    "https://img.freepik.com/premium-psd/biggest-sale-banner_1054968-2308.jpg",
  ];

  List<List<Color>> colorLists = [
    [Colors.black, Colors.blue, Colors.deepOrangeAccent, Colors.brown],
    [Colors.black, Colors.grey, Colors.redAccent, Colors.teal],
    [Colors.black, Colors.greenAccent, Colors.purple, Colors.blueGrey],
    [Colors.blue, Colors.orange, Colors.black, Colors.pinkAccent],
  ];

  void _addToCart(ProductModel product) {
    context.read<CartBloc>().add(AddToCartLocalEvent(product: product));
    context.read<CartBloc>().add(AddToCartAPIEvent(productId: product.id!, qty: 1));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.name} added to cart"),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.deepOrangeAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(
          label: "VIEW CART",
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.route_cart_page);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchAllProductEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 70),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: Color(0xffF0E8F2), shape: BoxShape.circle),
                    child: Center(child: Icon(Icons.menu, color: Colors.black)),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(color: Color(0xffF0E8F2), shape: BoxShape.circle),
                    child: Center(child: Icon(Icons.notifications_none_outlined, color: Colors.black)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 11),
            // Search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Color(0xffF0E8F2),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(51), borderSide: BorderSide.none),
                  ),
                ),
              ),
            ),
            SizedBox(height: 11),
            // Banner
            StatefulBuilder(
              builder: (context, ss) {
                return SizedBox(
                  height: 220,
                  child: Stack(
                    children: [
                      CarouselSlider(
                        items: bannerUrls.map((e) {
                          return Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(21),
                              child: Image.network(e, fit: BoxFit.cover, width: double.infinity),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 2),
                          height: 220,
                          onPageChanged: (index, _) {
                            currBannerPos = index;
                            ss(() {});
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 21,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DotsIndicator(
                            dotsCount: bannerUrls.length,
                            position: currBannerPos.toDouble(),
                            mainAxisAlignment: MainAxisAlignment.center,
                            decorator: DotsDecorator(
                              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(51)),
                              activeColor: Colors.black,
                              color: Colors.transparent,
                              activeSize: Size(14, 7),
                              spacing: EdgeInsets.symmetric(horizontal: 2),
                              size: Size(7, 7),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(51), side: BorderSide()),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 11),
            // Categories - STATIC LIST
            // Categories - Product image से लो
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                // Products load होने तक loading दिखाओ
                if (state is! ProductLoadedState) {
                  return SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      itemBuilder: (_, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 11),
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffF0E8F2),
                              ),
                              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            ),
                            SizedBox(height: 5),
                            Text(categories[index]["name"]),
                          ],
                        );
                      },
                    ),
                  );
                }

                // Products आ गए - अब category image निकालो
                final products = (state as ProductLoadedState).products;

                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (_, index) {
                      final category = categories[index];

                      // 👉 इस category का पहला product ढूंढो
                      final categoryProduct = products.firstWhere(
                            (p) => p.categoryId == category["id"],
                        orElse: () => ProductModel(), // नहीं मिला तो empty
                      );

                      // 👉 Product की image लो, नहीं तो default
                      final imageUrl = categoryProduct.image ?? "https://via.placeholder.com/70";

                      return InkWell(
                        onTap: () {
                          context.read<ProductBloc>().add(
                            FetchProductsByCategoryEvent(categoryId: category["id"]),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 11),
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(category["name"]),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            */
/*SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, index) {
                  final category = categories[index];
                  return InkWell(
                    onTap: () {
                      // 👉 CATEGORY TAP - Filter products
                      context.read<ProductBloc>().add(FetchProductsByCategoryEvent(categoryId: category["id"]));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 11),
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(category["image"]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(category["name"], style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                },
              ),

              /// =====
            ),*//*


            SizedBox(height: 11),
            // Title & See All
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Special For You", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      // 👉 SEE ALL TAP - All products
                      context.read<ProductBloc>().add(FetchAllProductEvent());
                    },
                    child: Text("See all", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 11),
            // Products Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is ProductErrorState) {
                    return Center(child: Text(state.errorMsg));
                  }

                  if (state is ProductLoadedState) {
                    if (state.products.isEmpty) {
                      return Center(child: Text("No products found"));
                    }

                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: state.products.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 11,
                        crossAxisSpacing: 11,
                        childAspectRatio: 11 / 12,
                      ),
                      itemBuilder: (_, index) {
                        final product = state.products[index];
                        final colors = colorLists[index % colorLists.length];

                        return InkWell(
                          onTap: () {
                            // 👉 PRODUCT TAP - Details page
                            Navigator.pushNamed(context, AppRoutes.route_detail_page, arguments: product);
                          },
                          child: Container(
                            decoration: BoxDecoration(color: Color(0xffF0E8F2), borderRadius: BorderRadius.circular(31)),
                            child: Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.network(product.image ?? "", width: 100, height: 100),
                                        SizedBox(height: 11),
                                        Text(product.name ?? "", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 11),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("₹ ${product.price}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(
                                                colors.length > 4 ? 4 : colors.length,
                                                    (childIndex) {
                                                  if (colors.length > 4 && childIndex == 3) {
                                                    return Container(width: 22, height: 22, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.transparent, border: Border.all(color: Colors.grey)), child: Center(child: Text("+${(colors.length - 3)}", style: TextStyle(color: Colors.grey, fontSize: 10))));
                                                  }
                                                  if (childIndex == 0) {
                                                    return SizedBox(width: 22, height: 22, child: Stack(children: [Container(width: 22, height: 22, decoration: BoxDecoration(border: Border.all(color: colors[childIndex]), shape: BoxShape.circle)), Center(child: Container(margin: EdgeInsets.all(3), width: 16, height: 16, decoration: BoxDecoration(color: colors[childIndex], shape: BoxShape.circle)))]));
                                                  }
                                                  return Container(margin: EdgeInsets.all(3), width: 16, height: 16, decoration: BoxDecoration(color: colors[childIndex], shape: BoxShape.circle));
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(color: Colors.deepOrangeAccent, borderRadius: BorderRadius.only(topRight: Radius.circular(21), bottomLeft: Radius.circular(11))),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () => _addToCart(product),
                                        icon: Icon(Icons.add_shopping_cart, color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/









/*
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/model/product_model.dart';
import '../../../../domain/constant/app_routes.dart';
import '../../../cart/cart_bloc.dart';
import '../../../cart/cart_event.dart';
import 'bloc/product_bloc.dart';
import 'bloc/product_event.dart';
import 'bloc/product_state.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currBannerPos = 0;

  List<String> bannerUrls = [
    "https://img.freepik.com/premium-vector/new-laptop-sale-promotion-social-facebook-cover-banner_252779-424.jpg?semt=ais_user_personalization&w=740&q=80 ",
    "https://img.freepik.com/premium-psd/biggest-sale-banner_1054968-2308.jpg?semt=ais_wordcount_boost&w=740&q=80 ",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQu_nPW7DJbYyg7JBtIUD08BLz8VOm7gwAKqA&s ",
    "https://img.freepik.com/premium-psd/biggest-sale-banner_1054968-2308.jpg?semt=ais_wordcount_boost&w=740&q=80 ",
  ];

  List<Map<String, dynamic>> productData = [
    {
      "name": "Wireless Headphones",
      "price": "120.00",
      "image": "https://picsum.photos/seed/headphones/400/400 ",
      "colorList": [
        Colors.black,
        Colors.blue,
        Colors.deepOrangeAccent,
        Colors.brown,
        Colors.amber,
      ],
    },
    {
      "name": "Smart Watch",
      "price": "199.99",
      "image": "https://picsum.photos/seed/smartwatch/400/400 ",
      "colorList": [Colors.black, Colors.grey, Colors.redAccent, Colors.teal],
    },
    {
      "name": "Gaming Mouse",
      "price": "59.49",
      "image": "https://picsum.photos/seed/mouse/400/400 ",
      "colorList": [
        Colors.black,
        Colors.greenAccent,
        Colors.purple,
        Colors.blueGrey,
      ],
    },
    {
      "name": "Bluetooth Speaker",
      "price": "89.00",
      "image": "https://picsum.photos/seed/speaker/400/400 ",
      "colorList": [
        Colors.blue,
        Colors.orange,
        Colors.black,
        Colors.pinkAccent,
      ],
    },
    {
      "name": "DSLR Camera",
      "price": "749.99",
      "image": "https://picsum.photos/seed/camera/400/400 ",
      "colorList": [
        Colors.black,
        Colors.grey,
        Colors.brown,
        Colors.indigo,
        Colors.deepPurple,
      ],
    },
    {
      "name": "Laptop Backpack",
      "price": "49.99",
      "image": "https://picsum.photos/seed/backpack/400/400 ",
      "colorList": [
        Colors.black,
        Colors.blueGrey,
        Colors.indigo,
        Colors.deepPurple,
        Colors.blueGrey,
        Colors.indigo,
        Colors.deepPurple,
      ],
    },
    {
      "name": "Running Shoes",
      "price": "129.99",
      "image": "https://picsum.photos/seed/shoes/400/400 ",
      "colorList": [Colors.white, Colors.black, Colors.red, Colors.blue],
    },
    {
      "name": "Fitness Band",
      "price": "39.99",
      "image": "https://picsum.photos/seed/fitnessband/400/400 ",
      "colorList": [Colors.black, Colors.green, Colors.cyan, Colors.pink],
    },
    {
      "name": "Tablet Device",
      "price": "329.00",
      "image": "https://picsum.photos/seed/tablet/400/400 ",
      "colorList": [Colors.grey, Colors.black, Colors.blueAccent],
    },
    {
      "name": "Mechanical Keyboard",
      "price": "149.99",
      "image": "https://picsum.photos/seed/keyboard/400/400 ",
      "colorList": [
        Colors.black,
        Colors.white,
        Colors.orangeAccent,
        Colors.lightBlue,
      ],
    },
    {
      "name": "LED Monitor",
      "price": "229.99",
      "image": "https://picsum.photos/seed/monitor/400/400 ",
      "colorList": [Colors.black, Colors.grey, Colors.blueGrey],
    },
    {
      "name": "Power Bank",
      "price": "24.99",
      "image": "https://picsum.photos/seed/powerbank/400/400 ",
      "colorList": [Colors.black, Colors.white, Colors.indigo],
    },
    {
      "name": "Smartphone",
      "price": "699.00",
      "image": "https://picsum.photos/seed/smartphone/400/400 ",
      "colorList": [Colors.black, Colors.blue, Colors.purple, Colors.green],
    },
    {
      "name": "Office Chair",
      "price": "159.99",
      "image": "https://picsum.photos/seed/chair/400/400 ",
      "colorList": [Colors.black, Colors.brown, Colors.grey],
    },
    {
      "name": "Portable SSD",
      "price": "109.99",
      "image": "https://picsum.photos/seed/ssd/400/400 ",
      "colorList": [Colors.black, Colors.redAccent, Colors.blueGrey],
    },
  ];

  void _addToCart(ProductModel product) {
    context.read<CartBloc>().add(AddToCartLocalEvent(product: product));


    context.read<CartBloc>().add(AddToCartAPIEvent(
        productId: product.id!,
        qty: 1
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.name} added to cart"),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.deepOrangeAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: "VIEW CART",
          textColor: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.route_cart_page);
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchAllProductEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 70),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffF0E8F2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Icon(Icons.menu, color: Colors.black)),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffF0E8F2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.notifications_none_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 11),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Color(0xffF0E8F2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(51),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 11),
            StatefulBuilder(
              builder: (context, ss) {
                return SizedBox(
                  height: 220,
                  child: Stack(
                    children: [
                      CarouselSlider(
                        items: bannerUrls.map((e) {
                          return Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(21),
                              child: Image.network(
                                e,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                          );
                        }).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 2),
                          autoPlayCurve: Curves.slowMiddle,
                          height: 220,
                          onPageChanged: (index, _) {
                            currBannerPos = index;
                            ss(() {});
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 21,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DotsIndicator(
                            dotsCount: bannerUrls.length,
                            animate: true,
                            position: currBannerPos.toDouble(),
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            decorator: DotsDecorator(
                              activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(51),
                              ),
                              activeColor: Colors.black,
                              color: Colors.transparent,
                              activeSize: Size(14, 7),
                              spacing: EdgeInsets.symmetric(horizontal: 2),
                              size: Size(7, 7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(51),
                                side: BorderSide(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 11),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (_, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 11),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                              "https://mir-s3-cdn-cf.behance.net/project_modules/fs/3ce709113389695.60269c221352f.jpg ",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(),
                      Text('Shoes'),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 11),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Special For You",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "See all",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 11),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state is ProductErrorState) {
                    return Center(child: Text(state.errorMsg));
                  }

                  if (state is ProductLoadedState) {
                    return GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: state.products.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 11,
                        crossAxisSpacing: 11,
                        childAspectRatio: 11 / 12,
                      ),
                      itemBuilder: (_, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.route_detail_page,
                              arguments: state.products[index],
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
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Image.network(
                                          state.products[index].image ??
                                              productData[index]["image"],
                                          width: 100,
                                          height: 100,
                                        ),
                                        SizedBox(height: 11),
                                        Text(
                                          state.products[index].name ?? "",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 11),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "₹ ${state.products[index].price}",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.end,
                                              spacing: 0,
                                              children: List.generate(
                                                productData[index]["colorList"]
                                                    .length >
                                                    4
                                                    ? 4
                                                    : productData[index]["colorList"]
                                                    .length,
                                                    (childIndex) {
                                                  if (productData[index]["colorList"]
                                                      .length >
                                                      4) {
                                                    print(
                                                      (productData[index]["colorList"]
                                                          .length),
                                                    );
                                                    if (childIndex == 3) {
                                                      return Container(
                                                        width: 22,
                                                        height: 22,
                                                        decoration:
                                                        BoxDecoration(
                                                          shape: BoxShape
                                                              .circle,
                                                          color: Colors
                                                              .transparent,
                                                          border: Border.all(
                                                            color:
                                                            Colors.grey,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "+${(productData[index]["colorList"].length - 3)}",
                                                            style: TextStyle(
                                                              color:
                                                              Colors.grey,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      if (childIndex == 0) {
                                                        return SizedBox(
                                                          width: 22,
                                                          height: 22,
                                                          child: Stack(
                                                            children: [
                                                              Container(
                                                                width: 22,
                                                                height: 22,
                                                                decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                    color:
                                                                    productData[index]["colorList"][childIndex],
                                                                  ),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                              ),
                                                              Center(
                                                                child: Container(
                                                                  margin:
                                                                  EdgeInsets.all(
                                                                    3,
                                                                  ),
                                                                  width: 22,
                                                                  height: 22,
                                                                  decoration: BoxDecoration(
                                                                    color:
                                                                    productData[index]["colorList"][childIndex],
                                                                    shape: BoxShape
                                                                        .circle,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      } else {
                                                        return Container(
                                                          margin:
                                                          EdgeInsets.all(3),
                                                          width: 19,
                                                          height: 19,
                                                          decoration: BoxDecoration(
                                                            color:
                                                            productData[index]["colorList"][childIndex],
                                                            shape:
                                                            BoxShape.circle,
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  } else {
                                                    if (childIndex == 0) {
                                                      return SizedBox(
                                                        width: 22,
                                                        height: 22,
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              width: 22,
                                                              height: 22,
                                                              decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  color:
                                                                  productData[index]["colorList"][childIndex],
                                                                ),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                            ),
                                                            Center(
                                                              child: Container(
                                                                margin:
                                                                EdgeInsets.all(
                                                                  3,
                                                                ),
                                                                width: 22,
                                                                height: 22,
                                                                decoration: BoxDecoration(
                                                                  color:
                                                                  productData[index]["colorList"][childIndex],
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    } else {
                                                      return Container(
                                                        margin: EdgeInsets.all(
                                                          3,
                                                        ),
                                                        width: 19,
                                                        height: 19,
                                                        decoration: BoxDecoration(
                                                          color:
                                                          productData[index]["colorList"][childIndex],
                                                          shape:
                                                          BoxShape.circle,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ///  => ADD TO CART
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
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () {
                                          _addToCart(state.products[index]);
                                        },
                                        icon: Icon(
                                          Icons.add_shopping_cart,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
