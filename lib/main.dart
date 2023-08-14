// ignore_for_file: library_private_types_in_public_api, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Translation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TranslationPage(),
    );
  }
}

class TranslationPage extends StatefulWidget {
  const TranslationPage({Key? key}) : super(key: key);

  @override
  _TranslationPageState createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
  final translator = GoogleTranslator();
  List<Language> languages = Language.getLanguages();
  late Language selectedLanguage;
  String inputText = '';
  String translatedText = '';

  Future<void> translateText() async {
    if (selectedLanguage != null) {
      final translation =
          await translator.translate(inputText, to: selectedLanguage.code);
      setState(() {
        translatedText = translation.text;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedLanguage = languages.isNotEmpty ? languages[0] : Language('', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translation App'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (text) {
                  setState(() {
                    inputText = text;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Enter text to translate',
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownButton<Language>(
                hint: const Text('Select a language'),
                value: selectedLanguage,
                onChanged: (Language? newValue) {
                  setState(() {
                    selectedLanguage = newValue!;
                  });
                },
                items: languages
                    .map<DropdownMenuItem<Language>>((Language language) {
                  return DropdownMenuItem<Language>(
                    value: language,
                    child: Text(language.name),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: translateText,
                child: const Text('Translate'),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Translated Text:',
                style: TextStyle(fontSize: 18.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                translatedText,
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Language {
  final String name;
  final String code;

  Language(this.name, this.code);

  static List<Language> getLanguages() {
    return [
      Language('English', 'en'),
      Language('Spanish', 'es'),
      Language('French', 'fr'),
      Language('Telugu', 'te')
      // Add more languages here
    ];
  }
}
