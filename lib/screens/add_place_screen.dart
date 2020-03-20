import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/screens/camera_screen.dart';
import 'package:sweepstakes/widgets/location_input.dart';

import '../providers/great_places.dart';
import '../models/place.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  double price;
  final _priceController = TextEditingController();
  String emailText;
  final _emailController = TextEditingController();
  String phoneText;
  final _phoneController = TextEditingController();
  String descriptionText;
  String titleText;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  Future<void> _savePlace() async {
    if (_descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _titleController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _pickedImage == null ||
        _pickedLocation == null) {
      return;
    }
    await Provider.of<GreatPlaces>(context, listen: false).addPlace(
      _titleController.text,
      _pickedImage,
      _pickedLocation,
      _descriptionController.text,
      _emailController.text,
      _phoneController.text,
      double.parse(_priceController.text),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Title: ',
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.only(
                            bottom: 10.0, left: 10.0, right: 10.0),
                      ),
                      controller: _titleController,
                      keyboardType: TextInputType.text,
                      onEditingComplete: () {
                        titleText = _titleController.text;

                        ///print(databaseText);
                      },
                    ),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Description: ',
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.only(
                            bottom: 10.0, left: 10.0, right: 10.0),
                      ),
                      controller: _descriptionController,
                      keyboardType: TextInputType.multiline,
                      onEditingComplete: () {
                        descriptionText = _descriptionController.text;

                        ///print(databaseText);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Price: ',
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.only(
                            bottom: 10.0, left: 10.0, right: 10.0),
                      ),
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      onEditingComplete: () {
                        price = double.parse(_priceController.text);

                        ///print(databaseText);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Email: ',
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.only(
                            bottom: 10.0, left: 10.0, right: 10.0),
                      ),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      onEditingComplete: () {
                        emailText = _emailController.text;

                        ///print(databaseText);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Phone: ',
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.only(
                            bottom: 10.0, left: 10.0, right: 10.0),
                      ),
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      onEditingComplete: () {
                        phoneText = _phoneController.text;

                        ///print(databaseText);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ImageInput(_selectImage),
                    SizedBox(
                      height: 10,
                    ),
                    LocationInput(_selectPlace),
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Add Place'),
            onPressed: _savePlace,
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
    );
  }
}
