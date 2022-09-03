import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

class LanguageIdentifierView extends StatefulWidget {
  const LanguageIdentifierView({Key? key}) : super(key: key);

  @override
  State<LanguageIdentifierView> createState() => _LanguageIdentifierViewState();
}

class _LanguageIdentifierViewState extends State<LanguageIdentifierView> {
  final TextEditingController _controller = TextEditingController();

  ///---------- Focus Here ---------------///
  final _languageIdentifier = LanguageIdentifier(confidenceThreshold: 0.5);
  List<IdentifiedLanguage> _identifiedLanguages = <IdentifiedLanguage>[];
  String _identifiedLanguage = '';

  ///---------- Focus Here ---------------///
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language Identification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              icon: Icon(Icons.edit),
              border: OutlineInputBorder(),
              labelText: "Enter Text to identify",
            ),
            maxLines: null,
          ),
          const SizedBox(height: 15),
          _identifiedLanguage == ''
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  // TODO: Show Identified Language
                  child: Text(
                    'TODO: Show Identified Language',
                    style: const TextStyle(fontSize: 20),
                  )),
          ElevatedButton(
            onPressed: _identifyLanguage,
            child: const Text('Identify Language'),
            style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                primary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50)),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: _identifyPossibleLanguages,
            child: const Text('Identify possible languages'),
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              primary: Colors.indigo,
              padding: EdgeInsets.symmetric(horizontal: 25),
            ),
          ),
          //TODO: Show Identified Possible Languages
          Text("TODO: Show Identified Possible Languages")
        ]),
      ),
    );
  }

  ///---------- Focus Here ---------------///
  Future<void> _identifyLanguage() async {
    if (_controller.text == '') return;
    String language;

    // TODO: Identify Language

    setState(() {});
  }

  Future<void> _identifyPossibleLanguages() async {
    if (_controller.text == '') return;

    // TODO: Identify Possible Languages
    setState(() {});
  }

  ///---------- Focus Here ---------------///

  @override
  void dispose() {
    _languageIdentifier.close();
    super.dispose();
  }
}
