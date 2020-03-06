import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/models/sweepstake.dart';
import 'package:sweepstakes/providers/sweepstakes.dart';
import 'package:sweepstakes/screens/camera_screen.dart';
import 'package:sweepstakes/widgets/app_drawer.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class AddingSweepstake extends StatefulWidget {
  static const routeName = 'add-sweepstake';
  final Function onSelectImage;

  AddingSweepstake(this.onSelectImage);
  @override
  _AddingSweepstakeState createState() => _AddingSweepstakeState();
}

class _AddingSweepstakeState extends State<AddingSweepstake> {
  //global key for form
  final _form = GlobalKey<FormState>();
  var _editedProduct = Sweepstake(
    id: null,
    title: '',
    price: 0,
    dateTime: '',
    image: null,
  );

  var _initValues = {
    'title': '',
    'dateTime': '',
    'price': '',
    'image': null,
  };

  var _isInIt = true;
  var _isLoading = false;

  //focuses on next input on keyboard after you click next
  final _priceFocusNode = FocusNode();
  final _dateTimeFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  //custom text editing controller
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInIt) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Sweepstakes>(context, listen: false)
            .findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'dateTime': _editedProduct.dateTime,
          'price': _editedProduct.price.toString(),
          'image': _editedProduct.image.readAsStringSync(),
        };
        _imageUrlController.text = _editedProduct.image.readAsStringSync();
      }
    }
    _isInIt = false;
    super.didChangeDependencies();
  }

  //you have to dispose focus nodes because it will stay in memory and caue memory leak
  @override
  void dispose() {
    // TODO: implement dispose
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _dateTimeFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  File _pickedImage;

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Sweepstakes>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Sweepstakes>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('an error occured!'),
                  content: Text('Uh oh, something went wrong :('),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
              print(Sweepstake);
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                //scrollable form, if in landscape mode form widget doesnt lose data
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                        //when moving to next input via mobile keyboard
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Sweepstake(
                            title: value,
                            price: _editedProduct.price,
                            dateTime: _editedProduct.dateTime,
                            image: _editedProduct.image,
                            id: _editedProduct.id,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['price'],
                        decoration: InputDecoration(labelText: 'Price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_dateTimeFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a price.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a number greater than zero';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Sweepstake(
                            title: _editedProduct.title,
                            price: double.parse(value),
                            dateTime: _editedProduct.dateTime,
                            image: _editedProduct.image,
                            id: _editedProduct.id,
                          );
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['dateTime'],
                        decoration: InputDecoration(labelText: 'Date'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _dateTimeFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a date';
                          }
                          if (value.length < 4) {
                            return 'Should be atleast 4 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Sweepstake(
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            dateTime: value,
                            image: _editedProduct.image,
                            id: _editedProduct.id,
                          );
                        },
                      ),
                      ImageInput(_selectImage),

                      // Row(
                      //   children: <Widget>[
                      //     Container(
                      //       width: 150,
                      //       height: 100,
                      //       decoration: BoxDecoration(
                      //         border: Border.all(width: 1, color: Colors.grey),
                      //       ),
                      //       child: _storedImage != null
                      //           ? Image.file(
                      //               _storedImage,
                      //               fit: BoxFit.cover,
                      //               width: double.infinity,
                      //             )
                      //           : FlatButton.icon(
                      //               icon: Icon(Icons.camera),
                      //               label: Text('Take Picture'),
                      //               textColor: Theme.of(context).primaryColor,
                      //               onPressed: _takePicture,
                      //             ),
                      //     ),
                      //     SizedBox(
                      //       width: 10,
                      //     ),
                      //     Expanded(
                      //       child: TextFormField(
                      //         decoration:
                      //             InputDecoration(labelText: 'Image URL'),
                      //         onSaved: (imageFile) {
                      //           _editedProduct = Sweepstake(
                      //             title: _editedProduct.title,
                      //             price: _editedProduct.price,
                      //             dateTime: _editedProduct.dateTime,
                      //             image: File(imageFile),
                      //             id: _editedProduct.id,
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
