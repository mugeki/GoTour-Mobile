// ignore_for_file: unused_field, non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gotour_mobile/api/firebase_api.dart';
import 'package:gotour_mobile/services/places.dart';
import 'package:gotour_mobile/widgets/main_menu.dart';
import 'package:image_picker/image_picker.dart';

class EditPlaceForm extends StatefulWidget {
  const EditPlaceForm({
    Key? key,
    required this.id,
    required this.name,
    required this.location,
    required this.description,
  }) : super(key: key);

  final int id;
  final String name;
  final String location;
  final String description;

  @override
  EditPlaceFormState createState() {
    return EditPlaceFormState();
  }
}

class EditPlaceFormState extends State<EditPlaceForm> {
  final ImagePicker imagePicker = ImagePicker();

  List<File> imageFileList = [];
  final _formKey = GlobalKey<FormState>();
  var nameCtrl = TextEditingController();
  var locationCtrl = TextEditingController();
  var descCtrl = TextEditingController();
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.name);
    locationCtrl = TextEditingController(text: widget.location);
    descCtrl = TextEditingController(text: widget.description);
    isLoading = false;
  }

  String? _validate(value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      final newImages = selectedImages.map((v) {
        return File(v.path);
      });
      setState(() {
        imageFileList.addAll(newImages);
      });
    }
  }

  Future<List<String>> uploadFile() async {
    List<String> imgsUrl = [];
    for (var imageFile in imageFileList) {
      final res = await FirebaseApi.uploadFile(imageFile);
      imgsUrl.add(res!);
    }
    return imgsUrl;
  }

  void _handleSubmit(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      List images;
      if (imageFileList.isNotEmpty) {
        images = await uploadFile();
      } else {
        images = [];
      }

      final response = await putPlace(
        widget.id,
        nameCtrl.text,
        locationCtrl.text,
        descCtrl.text,
        images,
      );
      if (response == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Place updated!'),
        ));
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MainMenu(menuIndex: 3),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Place'),
        foregroundColor: Theme.of(context).colorScheme.primary,
        backgroundColor: Colors.grey[50],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(50),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Place Name',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validate,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: locationCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validate,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: descCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: _validate,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            selectImages();
                          },
                          style: OutlinedButton.styleFrom(
                            primary: Colors.teal,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                          ),
                          child: const Text('Select Photo(s)')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  imageFileList.isEmpty
                      ? Container()
                      : GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 16 / 9,
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: imageFileList.length,
                          itemBuilder: (context, index) {
                            if (kIsWeb) {
                              return Image.network(
                                imageFileList[index].path,
                                fit: BoxFit.fitHeight,
                                height: 90,
                              );
                            }
                            return Image.file(
                              imageFileList[index],
                              fit: BoxFit.fitHeight,
                              height: 90,
                            );
                          },
                        ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : () => _handleSubmit(context),
                    child: isLoading
                        ? const SizedBox(
                            width: 17,
                            height: 17,
                            child: CircularProgressIndicator(),
                          )
                        : const Text('UPDATE PLACE'),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
