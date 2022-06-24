// ignore_for_file: unused_field, non_constant_identifier_names

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gotour_mobile/services/places.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:multi_image_picker/multi_image_picker.dart';

class AddPlaceForm extends StatefulWidget {
  const AddPlaceForm({
    super.key,
  });

  @override
  AddPlaceFormState createState() {
    return AddPlaceFormState();
  }
}

class AddPlaceFormState extends State<AddPlaceForm> {
  final ImagePicker imagePicker = ImagePicker();

  List<XFile>? imageFileList = [];

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    setState(() {});
  }

  // Future<List<String>> uploadFiles(List imageFileList) async {
  //   List<String> imagesUrls = [];

  //   imageFileList.forEach((imageFileList) async {
  //     FirebaseStorage.instance.ref().child('posts/${imageFileList.path}');
  //   });
  //   print(imagesUrls);
  //   return imagesUrls;
  // }

  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  // final imgCtrl = FileController();

  PlatformFile? pickedFile;
// upload single image to firebase
  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }

// select single image from gallery
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final response = await postPlace(
        nameCtrl.text,
        locationCtrl.text,
        descCtrl.text,
      );
      print('response code: ${response.meta.code}');
      if (response.meta.code == 200) {
        uploadFile();
        print("MASUK PAK EKOOOOOOOOOOO");
        const snackBar = SnackBar(
          content: Text('Place has been added!'),
        );
        // Navigator.pop(
        //   context,
        //   // MaterialPageRoute(builder: (context) => const MyPlaces()),
        // );
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                  labelText: 'Place Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: locationCtrl,
              decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: descCtrl,
              decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    selectFile();
                  },
                  style: OutlinedButton.styleFrom(
                    primary: Colors.teal,
                    backgroundColor: Colors.white,
                    // borderSide: const BorderSide(
                    //   color: Colors.teal,
                    // ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                  ),
                  child: pickedFile != true
                      ? const Text('Select Photo(s)')
                      : Text(pickedFile?.path ?? 'No file selected'),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    // uploadFile();
                    selectImages();
                  },
                  style: OutlinedButton.styleFrom(
                    primary: Colors.teal,
                    backgroundColor: Colors.white,
                    // borderSide: const BorderSide(
                    //   color: Colors.teal,
                    // ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                  ),
                  child: const Text('Take multi Photo(s)'),
                ),
              ],
            ),
            // const SizedBox(height: 5),
            Container(
              // child: Text(pickedFile!.name),
              child: Text(pickedFile?.path ?? 'No file selected'),
              // : Image.file(pickedFile?.path ?? 'No file selected'),
              // : Image.file(File(pickedFile!.path!)),
              // width: double.infinity,
              // fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadFile,
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 255, 255, 255)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              // padding:
              child: const Text(
                'upload',
                style: TextStyle(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _handleSubmit();
              },
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 255, 255, 255)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              // padding:
              child: const Text(
                'Add Place',
                style: TextStyle(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
