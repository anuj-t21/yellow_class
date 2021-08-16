import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yellow_class/utils/utility.dart';

class MoviePosterPicker extends StatefulWidget {
  MoviePosterPicker(this.imagePickFn, this.image);
  final Image? image;
  final void Function(String pickedImageString) imagePickFn;

  @override
  _MoviePosterPickerState createState() => _MoviePosterPickerState();
}

class _MoviePosterPickerState extends State<MoviePosterPicker> {
  File? _pickedImage;

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.gallery,
      maxWidth: 150,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    String imgString = Utility.base64String(pickedImageFile.readAsBytesSync());
    widget.imagePickFn(imgString);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          width: 100,
          margin: EdgeInsets.only(
            top: 8,
            right: 10,
          ),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey,
            backgroundImage: _pickedImage != null
                ? FileImage(_pickedImage!)
                : widget.image != null
                    ? widget.image!.image
                    : null,
          ),
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Upload Poster'),
        ),
//        ),
      ],
    );
  }
}
