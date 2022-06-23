import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gotour_mobile/services/places.dart';

class EditPlaceForm extends StatefulWidget {
  const EditPlaceForm(
      {Key? key,
      required this.name,
      required this.location,
      required this.description})
      : super(key: key);

  final String name;
  final String location;
  final String description;

  @override
  EditPlaceFormState createState() {
    return EditPlaceFormState();
  }
}

class EditPlaceFormState extends State<EditPlaceForm> {
  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.name);
    locationCtrl = TextEditingController(text: widget.location);
    descCtrl = TextEditingController(text: widget.description);
  }

  final _formKey = GlobalKey<FormState>();
  var nameCtrl = TextEditingController();
  var locationCtrl = TextEditingController();
  var descCtrl = TextEditingController();

  File? file;

  void _handleSubmit() async {
    // if (_formKey.currentState!.validate()) {
    //   final response =
    //       await putPlace(nameCtrl.text, locationCtrl.text, descCtrl.text);
    //   print('response code: ${response.meta.code}');
    //   if (response.meta.code == 200) {
    //     Navigator.pop(
    //       context,
    //       // MaterialPageRoute(builder: (context) => const MyPlaces()),
    //     );
    //   }
    // }
  }

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
                  onPressed: () {},
                  child: const Text('Select Photo(s)'),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.teal,
                    backgroundColor: Colors.white,
                    // borderSide: const BorderSide(
                    //   color: Colors.teal,
                    // ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Take Photo(s)'),
                  style: OutlinedButton.styleFrom(
                    primary: Colors.teal,
                    backgroundColor: Colors.white,
                    // borderSide: const BorderSide(
                    //   color: Colors.teal,
                    // ),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 255, 255, 255)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              // padding:
              child: const Text(
                'Edit Place',
                style: TextStyle(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future SelectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }
}
