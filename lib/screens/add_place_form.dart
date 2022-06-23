// ignore_for_file: unused_field, non_constant_identifier_names

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gotour_mobile/api/firebase_api.dart';
import 'package:gotour_mobile/services/places.dart';
import 'package:path/path.dart';

class AddPlaceForm extends StatefulWidget {
  const AddPlaceForm({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  AddPlaceFormState createState() {
    return AddPlaceFormState();
  }
}

class AddPlaceFormState extends State<AddPlaceForm> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  File? file;

  // Future getImage(ImageSource media) async {
  //   var img = await ImagePicker.pickImage(source: media);
  //   setState(() {
  //     _image = img as File;
  //   });
  // }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final response =
          await postPlace(nameCtrl.text, locationCtrl.text, descCtrl.text);
      print('response code: ${response.meta.code}');
      if (response.meta.code == 200) {
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
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : "No file selected";
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
                    SelectFile();
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
                  child: const Text('Select Photo(s)'),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () async {
                    // Take the Picture in a try / catch block. If anything goes wrong,
                    // catch the error.
                    try {
                      // Ensure that the camera is initialized.
                      await _initializeControllerFuture;

                      // Attempt to take a picture and get the file `image`
                      // where it was saved.
                      final image = await _controller.takePicture();

                      // If the picture was taken, display it on a new screen.
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                            // Pass the automatically generated path to
                            // the DisplayPictureScreen widget.
                            imagePath: image.path,
                          ),
                        ),
                      );
                    } catch (e) {
                      // If an error occurs, log the error to the console.
                      print(e);
                    }
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
                  child: const Text('Take Photo(s)'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _handleSubmit();
                UploadFile();
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

  Future SelectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future UploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    FirebaseApi.uploadFile(destination, file!);
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
