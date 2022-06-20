import 'package:flutter/material.dart';
import 'package:gotour_mobile/services/places.dart';
import 'package:gotour_mobile/widgets/main_menu.dart';

class AddPlaceForm extends StatefulWidget {
  final void Function(String type) toggleType;
  const AddPlaceForm({Key? key, required this.toggleType}) : super(key: key);

  @override
  AddPlaceFormState createState() {
    return AddPlaceFormState();
  }
}

class AddPlaceFormState extends State<AddPlaceForm> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final imgCtrl = TextEditingController();
  

  String? _validate(value) {
    if (value == null || value.isEmpty) {
      return 'Field cannot be empty';
    }
    return null;
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final response = await postPlace( nameCtrl.text, locationCtrl.text, descriptionCtrl.text, imgCtrl.text);
      print('response code: ${response.meta.code}');
      if (response.meta.code == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MainMenu()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(50),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              validator: _validate,
            ),
            TextFormField(
              controller: locationCtrl,
              decoration: const InputDecoration(
                labelText: 'Location',
                prefixIcon: Icon(Icons.location_pin),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              validator: _validate,
            ),
            TextFormField(
              controller: descriptionCtrl,
              decoration: const InputDecoration(
                labelText: 'Description',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              validator: _validate,
            ),
            TextFormField(
              controller: imgCtrl,
              decoration: const InputDecoration(
                labelText: 'Image',
                prefixIcon: Icon(Icons.image),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              validator: _validate,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('ADD'),
            ),
            const SizedBox(height: 5),
           



          ],