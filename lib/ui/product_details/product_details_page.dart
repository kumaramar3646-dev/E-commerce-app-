import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/product_model.dart';
import '../cart/cart_bloc.dart';
import '../cart/cart_event.dart';
import '../cart/cart_state.dart';

class ProductDetailPage extends StatefulWidget {
  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  ProductModel? currProduct;
  int qty = 1;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    currProduct = ModalRoute.of(context)!.settings.arguments as ProductModel;

    return Scaffold(
      backgroundColor: Color(0xffF0E8F2),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  color: Color(0xffF0E8F2),
                  child: Stack(
                    children: [
                      Center(
                        child: Image.network(
                          currProduct!.image!,
                          width: 200,
                          height: 200,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 60.0,
                          left: 21,
                          right: 21,
                        ),
                        child: Row(
                          children: [
                            // Back button
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.share_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 21),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.all(21),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(21),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currProduct!.name ?? "",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "₹${currProduct!.price ?? 0.00}",
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrangeAccent,
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.white,
                                          size: 12,
                                        ),
                                        Text(
                                          "4.8",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "(320 review)",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            "Seller: Tariqul Islam",
                            style: TextStyle(fontSize: 19),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Color",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 11),
                      SizedBox(
                        height: 44,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            Container(
                              margin: EdgeInsets.all(3),
                              width: 41,
                              height: 41,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 11),
                            SizedBox(
                              width: 44,
                              height: 44,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.brown),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      margin: EdgeInsets.all(3),
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: Colors.brown,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 11),
                            Container(
                              margin: EdgeInsets.all(3),
                              width: 41,
                              height: 41,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 11),
                            Container(
                              margin: EdgeInsets.all(3),
                              width: 41,
                              height: 41,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 11),
                            Container(
                              margin: EdgeInsets.all(3),
                              width: 41,
                              height: 41,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 88,
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.symmetric(horizontal: 21),
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.black,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Quantity Selector
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (qty > 1) {
                              setState(() {
                                qty--;
                              });
                            }
                          },
                          icon: Icon(Icons.remove, color: Colors.white),
                        ),
                        SizedBox(width: 11),
                        Text(
                          '$qty',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 21,
                          ),
                        ),
                        SizedBox(width: 11),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              qty++;
                            });
                          },
                          icon: Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // Add to Cart Button with Bloc
                  InkWell(
                    onTap: isLoading ? null : () {
                      // add local cart mein add
                      context.read<CartBloc>().add(
                        AddToCartLocalEvent(product: currProduct!),
                      );

                      // API call
                      context.read<CartBloc>().add(
                        AddToCartAPIEvent(
                          productId: currProduct!.id!,
                          qty: qty,
                        ),
                      );
                    },
                    child: BlocConsumer<CartBloc, CartState>(
                      listener: (context, state) {
                        if (state is CartLoadingState) {
                          setState(() {
                            isLoading = true;
                          });
                        }

                        if (state is CartFailureState) {
                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.errorMsg),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }

                        if (state is CartSuccessState) {
                          setState(() {
                            isLoading = false;
                          });

                          // SnackBar
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Item added to cart successfully!!"),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 1),
                            ),
                          );
                          Future.delayed(Duration(milliseconds: 500), () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      builder: (context, state) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 41,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isLoading ? Colors.grey : Colors.deepOrangeAccent,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: isLoading
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : Text(
                            'Add to cart',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}