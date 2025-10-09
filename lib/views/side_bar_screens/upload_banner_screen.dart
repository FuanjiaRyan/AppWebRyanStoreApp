import 'package:app_web_ryan_store_app/views/side_bar_screens/widgets/banner_list_widget.dart';
import 'package:app_web_ryan_store_app/views/side_bar_screens/widgets/category_list_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class UploadBannerScreen extends StatefulWidget {
  static const String id = '\UploadBannerScreen';
  const UploadBannerScreen({super.key});

  @override
  State<UploadBannerScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<UploadBannerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  dynamic _image;
  String? fileName;
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
    Reference ref = _firebaseStorage.ref().child('banners').child(fileName!);
    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  uploadToFireStore() async {
    if(_image!=null) {
      EasyLoading.show();
      String imageUrl = await _uploadImageToStorage(_image);
      await _firestore.collection('banners').doc(fileName).set({
        'image': imageUrl,
      }).whenComplete((){
        EasyLoading.dismiss();
        _image = null;
      });
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.topLeft,
              child: Text(
                'Banners',
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
          BannerListWidget(),
        ],
      ),
    );
  }
}
