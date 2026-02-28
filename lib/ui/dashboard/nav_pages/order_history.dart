import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_page/order_bloc/order_bloc.dart';
import 'home_page/order_bloc/order_event.dart';
import 'home_page/order_bloc/order_state.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {

  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(FetchOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoadingState) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is OrderErrorState) {
            return Center(child: Text(state.errorMsg));
          }

          if (state is OrderLoadedState) {
            if (state.orders.isEmpty) {
              return Center(child: Text("No orders found"));
            }

            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (_, index) {
                final order = state.orders[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text("Order #${order.id}"),
                    subtitle: Text("Date: ${order.date}"),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("₹ ${order.totalAmount}"),
                        Text(
                          order.status ?? "Pending",
                          style: TextStyle(
                            color: order.status == "Delivered"
                                ? Colors.green
                                : Colors.orange,
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
    );
  }
}