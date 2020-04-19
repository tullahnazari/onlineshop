import 'dart:io';

//import 'package:camera/new/src/camera_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  static const routeName = '/image-input';
  final Function onSelectImage;

  ImageInput(this.onSelectImage);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (imageFile == null) {
      return;
    }
    setState(() {
      _storedImage = imageFile;
    });
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
      ),
      child: _storedImage != null
          ? Image.file(
              _storedImage,
              fit: BoxFit.cover,
              width: double.infinity,
            )
          : RaisedButton(
              onPressed: () {
                _takePicture();
              },
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(18.0),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              elevation: 10,
              child: Text(
                'Please Take Picture',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
      alignment: Alignment.center,
    );
    // Expanded(
    //   child: FlatButton.icon(
    //     icon: Icon(Icons.camera),
    //     label: Text(
    //       'Take Picture',
    //       style: TextStyle(fontSize: 16),
    //     ),
    //     textColor: Theme.of(context).primaryColor,
    //     onPressed: _takePicture,
    //   ),
    // )
  }
}
