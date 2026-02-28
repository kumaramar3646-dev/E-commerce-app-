import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/constant/app_routes.dart';
import '../../cart/cart_bloc.dart';

class OrderSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Last order लो
    final bloc = context.read<CartBloc>();
    final lastOrder = bloc.orderHistory.isNotEmpty
        ? bloc.orderHistory.last
        : null;
    final products = lastOrder?["products"] as List<dynamic>? ?? [];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60),

            // Success Icon
            Icon(Icons.check_circle, size: 80, color: Colors.green),
            SizedBox(height: 20),

            Text("Order Placed!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            Text("Order #${lastOrder?["id"].toString().substring(8) ?? ""}",
                style: TextStyle(color: Colors.grey)),

            SizedBox(height: 20),

            //  Products with Images
            Container(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: products.length,
                itemBuilder: (_, index) {
                  final product = products[index] as Map<String, dynamic>;
                  return Container(
                    margin: EdgeInsets.only(right: 10),
                    width: 100,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product["image"] ?? "",
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Container(width: 80, height: 80, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          product["name"] ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            // Total
            Text(
              "Total: ₹ ${lastOrder?["total"] ?? 0}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 30),

            // Buttons
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.route_order_history_page);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrangeAccent,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text("View Order History"),
            ),

            SizedBox(height: 10),

            TextButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text("Continue Shopping"),
            ),
          ],
        ),
      ),
    );
  }
}









