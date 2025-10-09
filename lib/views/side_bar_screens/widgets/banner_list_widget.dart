import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BannerListWidget extends StatelessWidget {
  const BannerListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _bannersStream =
        FirebaseFirestore.instance.collection('banners').snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: _bannersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final categoryData = snapshot.data!.docs[index];
            return Column(
              children: [
                Image.network(categoryData['image'], height: 100, width: 100),
              ],
            );
          },
        );
      },
    );
  }
}
