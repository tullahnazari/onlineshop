import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:halalbazaar/screens/sweepstake_management.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:halalbazaar/screens/camera_screen.dart';
import 'package:halalbazaar/widgets/add_picture.dart';
import 'package:halalbazaar/widgets/location_input.dart';
import 'package:halalbazaar/widgets/upload_from_gallery.dart';

import '../providers/great_places.dart';
import '../models/place.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();

  String price;
  final _priceController = TextEditingController();
  String _chosenValue;
  final _categoryController = TextEditingController();
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
  List<String> imageList = [];
  List<Asset> images = List<Asset>();
  var _isLoading = false;
  var _showText = false;

  void _selectImage(List pickedImage) {
    imageList = pickedImage;
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  @override
  void initState() {
    super.initState();
    _showText = false;
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _savePlace() async {
    if (_descriptionController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _titleController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        imageList.isEmpty ||
        _chosenValue.isEmpty ||
        _pickedLocation == null ||
        _isLoading == true) {
      return Flushbar(
        title: "Hey, are you missing something?",
        message:
            "Please fill out all sections of the post in order to add posting",
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 5),
      )..show(context);
    } else {
      await Provider.of<GreatPlaces>(context, listen: false).addPlace(
        _titleController.text,
        imageList,
        _pickedLocation,
        _descriptionController.text,
        _emailController.text,
        _phoneController.text,
        _priceController.text,
        _chosenValue,
      );

      Navigator.of(context).pushNamed(SweepstakeManagement.routeName);
    }
  }

  Future<void> _getImageList() async {
    var resultList = await MultiImagePicker.pickImages(
      maxImages: 5,
      enableCamera: true,
    );

    // The data selected here comes back in the list
    print(resultList);
    setState(() {
      _isLoading = true;
      images = resultList;
    });
    for (var asset in resultList) {
      postImage(asset).then((downloadUrl) {
        //setState(() {
        //imageList.add(downloadUrl.toString());
        //_selectImage(downloadUrl);

        var test = imageList.add(downloadUrl.toString());

        setState(() {
          _isLoading = false;
          _showText = true;
        });

        // });
        // Get the download URL
        //print(downloadUrl.toString());
      }).catchError((err) {
        print(err);
      });
    }
  }

  Future<dynamic> postImage(Asset asset) async {
    ByteData byteData = await asset.requestOriginal(quality: 20);
    List<int> imageData = byteData.buffer.asUint8List();
    String fileName = DateTime.now().microsecondsSinceEpoch.toString() +
        DateTime.now().millisecondsSinceEpoch.toString() +
        DateTime.now().day.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putData(imageData);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    return storageTaskSnapshot.ref.getDownloadURL();
  }

  buildGridView() {
    //sepearate the two
    return Container(
      height: 200,
      width: double.infinity,
      child: GridView.count(
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      ),
    );
  }

  showText() {
    return Container(
      height: 200,
      width: double.infinity,
      child: Center(
        child: Text(
          'Please upload images by pressing upload button above',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );
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
                    DropdownButton<String>(
                      isExpanded: true,
                      hint: Text('Please select a category'),
                      value: _chosenValue,
                      underline: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent)),
                      ), // this is the magic
                      items: <String>[
                        'Wanted',
                        'Electronics',
                        'Vehicles',
                        'Home & Tools',
                        'Jobs & Services',
                        'Clothes',
                        'Food & Grocery',
                        'Community Gatherings'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String value) {
                        setState(() {
                          _chosenValue = value;
                        });
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                        elevation: 10,
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          'Upload Photos',
                          style:
                              TextStyle(color: Theme.of(context).accentColor),
                        ),
                        onPressed: _getImageList,
                      ),
                    ),
                    _isLoading
                        ? Container(
                            height: 200,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.teal,
                              strokeWidth: 6,
                            ),
                          )
                        : buildGridView(),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    LocationInput(_selectPlace),
                    TextFormField(
                      focusNode: _titleFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
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
                    TextFormField(
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
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
                    TextFormField(
                      focusNode: _emailFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_phoneFocusNode);
                      },
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
                    TextFormField(
                      focusNode: _phoneFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
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

                    TextFormField(
                      focusNode: _descriptionFocusNode,
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

                    SizedBox(
                      height: 10,
                    ),
                    // ImageInput(_selectImage),
                    // SizedBox(
                    //   height: 10,
                    // ),

                    //buildGridView(),
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
              onPressed: () {
                _savePlace();
              },
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
