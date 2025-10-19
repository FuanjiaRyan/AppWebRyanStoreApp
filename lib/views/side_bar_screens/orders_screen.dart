import 'package:app_web_ryan_store_app/views/side_bar_screens/widgets/order_list_widget.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  static const String id = 'ordersScreen';
  const OrdersScreen({super.key});

  Widget rowHeader(int flex, String text) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xff3c55ef),
          border: Border.all(color: Colors.grey.shade700),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Manage Orders',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Row(
            children: [
              rowHeader(1, 'Image'),
              rowHeader(3, 'Full Name'),
              rowHeader(2, 'Address'),
              rowHeader(1, 'Action'),
              rowHeader(1, 'Reject'),
            ],
          ),
          OrderListWidget(),
        ],
      ),
    );
  }
}
