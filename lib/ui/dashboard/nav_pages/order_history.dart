import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cart/cart_bloc.dart';
import '../../cart/cart_event.dart';
import '../../cart/cart_state.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {

  @override
  void initState() {
    super.initState();
    // Load orders
    context.read<CartBloc>().add(LoadCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          //  Clear All Button
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              _showClearAllDialog(context);
            },
          ),
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final bloc = context.read<CartBloc>();
          final orders = bloc.orderHistory;

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text("No orders yet", style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (_, index) {
              final order = orders[index];
              final products = order["products"] as List<dynamic>;

              return Dismissible(
                // Swipe to delete
                key: Key(order["id"]),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  _deleteOrder(context, order["id"]);
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order #${order["id"].toString().substring(8)}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${order["date"]}",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "₹ ${order["total"]}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),
                            Text(
                              "${order["status"]}",
                              style: TextStyle(
                                fontSize: 12,
                                color: order["status"] == "Delivered"
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    children: [
                      //  Product images
                      Container(
                        height: 100,
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          itemBuilder: (_, pIndex) {
                            final product = products[pIndex];
                            return Container(
                              margin: EdgeInsets.only(right: 10),
                              width: 80,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      product["image"] ?? "",
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          Container(width: 60, height: 60, color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    product["name"] ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    "x${product["quantity"]}",
                                    style: TextStyle(fontSize: 10, color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      // Delete button
                      ButtonBar(
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.delete, color: Colors.red),
                            label: Text("Delete Order", style: TextStyle(color: Colors.red)),
                            onPressed: () {
                              _showDeleteDialog(context, order["id"]);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Delete Single Order Dialog
  void _showDeleteDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Order?"),
        content: Text("This order will be permanently removed."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              _deleteOrder(context, orderId);
              Navigator.pop(context);
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  //  Delete Order
  void _deleteOrder(BuildContext context, String orderId) {
    context.read<CartBloc>().add(DeleteOrderEvent(orderId: orderId));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order deleted")),
    );
  }

  // Clear All Dialog
  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Clear All Orders?"),
        content: Text("All orders will be permanently removed."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              context.read<CartBloc>().add(ClearAllOrdersEvent());
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("All orders cleared")),
              );
            },
            child: Text("Clear All"),
          ),
        ],
      ),
    );
  }
}







