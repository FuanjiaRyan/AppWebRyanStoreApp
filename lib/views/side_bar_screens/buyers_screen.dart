import 'package:app_web_ryan_store_app/views/side_bar_screens/widgets/buyer_list_widget.dart';
import 'package:flutter/material.dart';

class BuyersScreen extends StatelessWidget {
  static const String id = '\buyerscreen';
  const BuyersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget rowHeader(int flex, String text) {
      return Expanded(
        flex: flex,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700),
            color: Color(0xff3c55ef),
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Manage Buyers',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                rowHeader(1, 'Image'),
                rowHeader(3, 'Full Name'),
                rowHeader(2, 'Address'),
                rowHeader(2, 'Email'),
              ],
            ),
            BuyerListWidget(),
          ],
        ),
      ),
    );
  }
}
