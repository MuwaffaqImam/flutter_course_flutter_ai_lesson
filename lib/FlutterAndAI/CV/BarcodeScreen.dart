import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;

class BarcodeScannerView extends StatefulWidget {
  @override
  _BarcodeScannerViewState createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  bool isLoading = false;
  final picker = ImagePicker();
  List<Barcode> barcodes = [];
  late ui.Image _image;
  File? _imageFile;
  XFile? imageFile;

  ///---------- Focus Here ---------------///
  final BarcodeScanner _barcodeScanner = BarcodeScanner();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
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

    // TODO: get the barcodes

    if (barcodes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nothing is detected, try again!')));
      return;
    }
// ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text('Nothing is detected, try again!')));
    setState(() {});
  }

  ///---------- Focus Here ---------------///
  _getImageFromGallery() async {
    imageFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      isLoading = true;
    });

    if (mounted) {
      if (imageFile != null) {
        setState(() {
          _imageFile = File(imageFile!.path);
          _loadImage(File(imageFile!.path));
          processImage(InputImage.fromFile(_imageFile!));
        });
      }
    }
  }

  _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then((value) => setState(() {
          _image = value;
          isLoading = false;
        }));
  }

  /// Build UI
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

  Column BuildAIView() {
    return Column(
      children: [
        Center(
          child: FittedBox(
            child: SizedBox(
                width: _image.width.toDouble(),
                height: _image.height.toDouble(),
                child: Image.file(_imageFile!)),
          ),
        ),
        // TODO: Display Barcodes!
        if (barcodes.isNotEmpty) Text("TODO: Display Barcodes!")
      ],
    );
  }

  @override
  void dispose() {
    _barcodeScanner.close();
    super.dispose();
  }
}
