import 'package:app_web_ryan_store_app/views/side_bar_screens/widgets/category_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = 'categoryScreen';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  dynamic _image;
  String? fileName;
  late String categoryName;
  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }
  }

  _uploadImageToStorage(dynamic image) async{
   Reference ref = _firebaseStorage.ref().child('categories').child(fileName!);
  UploadTask uploadTask = ref.putData(image);
  TaskSnapshot snap = await uploadTask;
  String downloadUrl = await snap.ref.getDownloadURL();
  return downloadUrl;
  }

  uploadToFireStore() async {
    if(_formKey.currentState!.validate()) {
      if(_image!=null) {
        EasyLoading.show();
        String imageUrl = await _uploadImageToStorage(_image);
        await _firestore.collection('categories').doc(fileName).set({
          'categoryName': categoryName,
          'categoryImage': imageUrl,
        }).whenComplete((){
          EasyLoading.dismiss();
          _image = null;
        });
      } else {
        EasyLoading.dismiss();
      }
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(color: Colors.grey),
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      height: 140,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                        border: Border.all(color: Colors.grey.shade800),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child:
                            _image != null
                                ? Image.memory(_image)
                                : Text(
                                  'Upload Image',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        pickImage();
                      },
                      child: Text(
                        'Upload Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 30),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    onChanged: (value) {
                      categoryName = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'please enter category name';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(labelText: 'Category Name'),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(
                      BorderSide(color: Colors.blueAccent.shade700),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    uploadToFireStore();
                  },
                  child: Text('Save'),
                ),
              ],
            ),
            const CategoryListWidget(),
          ],
        ),
      ),
    );
  }
}
