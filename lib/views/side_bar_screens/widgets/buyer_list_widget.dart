import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BuyerListWidget extends StatelessWidget {
  const BuyerListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> buyersStream =
        FirebaseFirestore.instance.collection('buyers').snapshots();
    Widget BuyerData(Widget widget, int? flex) {
      return Expanded(
        flex: flex!,
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
          child: Padding(padding: EdgeInsets.all(8), child: widget),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: buyersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final buyer = snapshot.data!.docs[index];
            return Row(
              children: [
                BuyerData(
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.network(
                      'https://www.bing.com/images/search?view=detailV2&ccid=hEn3Gg4F&id=8A5971249442AE1DEE06E2F88DC392DAE36D4A1E&thid=OIP.hEn3Gg4Fy1eM9DW2-7h1_QHaGL&mediaurl=https%3a%2f%2fimages.publicpeople.org%2findex-large%2fman-in-jean-shirt-with-beard.jpg&cdnurl=https%3a%2f%2fth.bing.com%2fth%2fid%2fR.8449f71a0e05cb578cf435b6fbb875fd%3frik%3dHkpt49qSw4344g%26pid%3dImgRaw%26r%3d0&exph=717&expw=859&q=man&FORM=IRPRST&ck=0397CA44595AF21ED56925771C72821C&selectedIndex=10&itb=0',
                    ),
                  ),
                  1,
                ),
                BuyerData(Text(buyer['fullName']), 3),
                BuyerData(Text(buyer['locality']), 2),
                BuyerData(Text(buyer['email']), 2),
              ],
            );
          },
        );
      },
    );
  }
}
