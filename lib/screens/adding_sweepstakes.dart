import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sweepstakes/models/sweepstake.dart';
import 'package:sweepstakes/providers/sweepstakes.dart';
import 'package:sweepstakes/widgets/app_drawer.dart';

class AddingSweepstake extends StatefulWidget {
  static const routeName = 'add-sweepstake';
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
    imageUrl: '',
  );

  var _initValues = {
    'title': '',
    'dateTime': '',
    'price': '',
    'imageUrl': '',
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
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
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
                            imageUrl: _editedProduct.imageUrl,
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
                            imageUrl: _editedProduct.imageUrl,
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
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                          );
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.blueGrey),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child:
                                        Image.network(_imageUrlController.text),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) => {_saveForm()},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter an image URL.';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid URL';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg')) {
                                  return 'Please upload a png or jpg image';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _editedProduct = Sweepstake(
                                  title: _editedProduct.title,
                                  price: _editedProduct.price,
                                  dateTime: _editedProduct.dateTime,
                                  imageUrl: value,
                                  id: _editedProduct.id,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
