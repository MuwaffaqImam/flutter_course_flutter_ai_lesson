import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

class FaceDetectionPage extends StatefulWidget {
  const FaceDetectionPage({Key? key}) : super(key: key);

  @override
  FaceDetectionPageState createState() => FaceDetectionPageState();
}

class FaceDetectionPageState extends State<FaceDetectionPage> {
  bool isLoading = false;
  final picker = ImagePicker();

  late ui.Image _image;
  File? _imageFile;
  XFile? imageFile;


  ///---------- Focus Here ---------------///
  List<Face> _faces = [];
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  ///---------- Focus Here ---------------///

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Face Detection'),
      ),
       floatingActionButton: FloatingActionButton(
          onPressed: _getImageFromGallery,
          tooltip: 'Get Image',
          child: const Icon(Icons.add_a_photo),
        ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_imageFile == null)
              ? buildEmptyView()
              : BuildAIView(),
    );
  }

  ///---------- Focus Here ---------------///
  Future<void> processImage(InputImage inputImage) async {
    setState(() {
      isLoading = true;
    });

    // TODO: Get the Faces

    if (_faces.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nothing is detected, try again!')));
      return;
    }
    setState(() {
      isLoading = false;
    });
  }
  ///---------- Focus Here ---------------///
  Column BuildAIView() {
    // TODO: Show when the face is sleep or smiling or winking
    return Column(
      children: [
        FittedBox(
          child: SizedBox(
              width: _image.width.toDouble(),
              height: _image.height.toDouble(),
              child: CustomPaint(
                painter: FacePainter(_image, _faces),
              )),
        ),
          Text(
            'Face is smiling',
            style: TextStyle(fontSize: 30),
          ),
          Text(
            'Face is winking',
            style: TextStyle(fontSize: 30),
          ),
          Text(
            'Face is sleeping',
            style: TextStyle(fontSize: 30),
          )
      ],
    );
  }

Widget buildEmptyView() {
    return InkWell(
      onTap: _getImageFromGallery,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 150,
            child: Icon(
              Icons.add_a_photo,
              size: 150,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text("Click here to add an Image")
        ],
      )),
    );
  }


  _getImageFromGallery() async {
    imageFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      isLoading = true;
    });
    if (imageFile != null) {
      setState(() {
        _imageFile = File(imageFile!.path);
        processImage(InputImage.fromFile(_imageFile!));
        _loadImage(File(imageFile!.path));
      });
    }
  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then((value) => setState(() {
          _image = value;
          isLoading = false;
        }));
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }
}

// paint the face
class FacePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;
  final List<Rect> rects = [];

  FacePainter(this.image, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    List<Offset> offsets = [];
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..color = Colors.red;

    canvas.drawImage(image, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
      offsets.add(rects[i].topRight);
    }
  }

  @override
  bool shouldRepaint(FacePainter old) {
    return image != old.image || faces != old.faces;
  }
}
