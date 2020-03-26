import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
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
  String price;
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
      return Flushbar(
        title: "Hey, are you missing something?",
        message:
            "Please fill out all sections of the post in order to add posting",
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 5),
      )..show(context);
    }
    await Provider.of<GreatPlaces>(context, listen: false).addPlace(
      _titleController.text,
      _pickedImage,
      _pickedLocation,
      _descriptionController.text,
      _emailController.text,
      _phoneController.text,
      _priceController.text,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Product or Service'),
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
                    ImageInput(_selectImage),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        hintText: 'Title: ',
                        fillColor: Colors.white,
                        border: InputBorder.none,
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
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        hintText: 'Description: ',
                        fillColor: Colors.white,
                        border: InputBorder.none,
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
                    // TextField(
                    //   decoration: InputDecoration(
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide:
                    //           BorderSide(color: Colors.greenAccent, width: 1.0),
                    //     ),
                    //     enabledBorder: OutlineInputBorder(
                    //       borderSide:
                    //           BorderSide(color: Colors.black, width: 1.0),
                    //     ),
                    //     hintText: 'Amount:',
                    //     fillColor: Colors.white,
                    //   ),
                    //   controller: _priceController,
                    //   textInputAction: TextInputAction.done,
                    //   keyboardType:
                    //       TextInputType.numberWithOptions(decimal: true),
                    // ),
                    // MoneyTextFormField(
                    //     settings: MoneyTextFormFieldSettings(
                    //         controller: _priceController,
                    //         appearanceSettings:
                    //             AppearanceSettings(hintText: 'Price'),
                    //         moneyFormatSettings: MoneyFormatSettings(
                    //             displayFormat:
                    //                 MoneyDisplayFormat.),
                    //         onChanged: () {
                    //           price = double.parse(_priceController.text);
                    //         })),
                    TextField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        hintText: 'Price: ',
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.only(
                            bottom: 10.0, left: 10.0, right: 10.0),
                      ),
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      onEditingComplete: () {
                        price = _priceController.text;

                        ///print(databaseText);
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        hintText: 'Email: ',
                        fillColor: Colors.white,
                        border: InputBorder.none,
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
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.greenAccent, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.0),
                        ),
                        hintText: 'Phone: ',
                        fillColor: Colors.white,
                        border: InputBorder.none,
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
                    // ImageInput(_selectImage),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    LocationInput(_selectPlace),
                  ],
                ),
              ),
            ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     border: Border.all(width: 3, color: Colors.black),
          //   ),
          //   child:
          Container(
            height: 55,
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              icon: Icon(Icons.add, color: Theme.of(context).accentColor),
              label: Text(
                'Add Posting',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onPressed: _savePlace,
              elevation: 10,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              color: Theme.of(context).primaryColor,
            ),
          ),
          // ),
        ],
      ),
    );
  }
}
