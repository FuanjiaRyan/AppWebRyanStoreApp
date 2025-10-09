import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  static const String id = '\productScreen';

  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _sizeController = TextEditingController();
  final List<String> _categoryList = [];
  final List<String> _sizeList = [];
  String? selectedCategory;
  bool _isEntered = false;
  final List<Uint8List> _images = [];

  chooseImage() async {
    final pickedImages = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (pickedImages == null) {
      print('No Image Picked');
    } else {
      setState(() {
        for (var file in pickedImages.files) {
          _images.add(file.bytes!);
        }
      });
    }
  }

  _getCategories() {
    return _firestore.collection('categories').get().then((
      QuerySnapshot querySnapshot,
    ) {
      for (var doc in querySnapshot.docs) {
        setState(() {
          _categoryList.add(doc['categoryName']);
        });
      }
    });
  }

  @override
  void initState() {
    _getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Product Information',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter Product Name',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter Price',
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Flexible(child: buildDropDownField()),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Discount',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Enter Description',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  child: SizedBox(
                    width: 200,
                    child: TextFormField(
                      controller: _sizeController,
                      onChanged: (value) {
                        setState(() {
                          _isEntered = true;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Add Size',
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                _isEntered == true
                    ? Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _sizeList.add(_sizeController.text);
                          });
                        },
                        child: Text('Add'),
                      ),
                    )
                    : Text(''),
              ],
            ),
            _sizeList.isNotEmpty
                ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                      itemCount: _sizeList.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.shade700,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _sizeList[index],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
                : Text(''),
            SizedBox(height: 20),
            GridView.builder(
              itemCount: _images.length + 1,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return index == 0
                    ? Center(
                      child: IconButton(
                        onPressed: () {
                          chooseImage();
                        },
                        icon: Icon(Icons.add),
                      ),
                    )
                    : Image.memory(_images[index - 1]);
              },
            ),

            InkWell(
              onTap: () {},
              child: Container(
                width: MediaQuery.of(context).size.width - 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.shade700,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Center(
                  child: Text(
                    'Upload Product',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDropDownField() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        labelText: 'Select category',
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      items:
          _categoryList.map((value) {
            return DropdownMenuItem(value: value, child: Text(value));
          }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            selectedCategory = value;
          });
        }
      },
    );
  }
}
