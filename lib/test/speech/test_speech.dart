import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum TtsState { playing, stopped, paused, continued }

class SpeechCustomTest extends StatefulWidget {
  @override
  _SpeechCustomTestState createState() => _SpeechCustomTestState();
}

class _SpeechCustomTestState extends State<SpeechCustomTest> {
  bool _hasSpeech = false;
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastWords = "";
  String lastWords2 = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();
  late FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;

  @override
  void initState() {
    initSpeechState();
    initTts();
    super.initState();
  }

  initTts() async {
    flutterTts = FlutterTts();

    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setPitch(1.1);

    await flutterTts.awaitSpeakCompletion(true);

    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<void> initSpeechState() async {

    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);

    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale!.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Palabras reconocidas',
              style: TextStyle(fontSize: 22.0),
            ),
            SizedBox(
              height: 30,
              child: Center(
                child: Text(
                  lastWords,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => startListening(),
              child: const SizedBox(
                height: 80,
                child: Icon(Icons.mic,size: 80,)),
            ),
            GestureDetector(
              onTap: () => stopListening(),
              child: const SizedBox(
                  height: 80,
                  child: Icon(Icons.stop,size: 80,)),
            ),
            GestureDetector(
              onTap: () async => _recognized(),
              child: const SizedBox(
                  height: 50,
                  child: Text('Procesar')),
            ),
          ],
        ),
      ),
    );
  }

  _recognized() async {
    try{
      // lastWords = 'HOLA';
      await flutterTts.speak('Procesando');
      print('Palabras: ' + lastWords);
      bool bp = false;

      bp = lastWords.contains('Agregar nota para recordar que ');

      // await flutterTts.speak('El valor de la variable es ' +
      //     lastWords.contains('Agregar nota para recordar que ').toString() +
      //     ' pero he reconocido estas palabras ' );

      await flutterTts.speak('He reconocido estas palabras para agregar a la nota: ' + lastWords.substring(lastWords.indexOf('Agregar nota para recordar que ', lastWords.length)));

      if (bp) {
        print('op1');
        await FirebaseFirestore.instance
            .collection('rec_mar')
            .doc('listas')
            .collection('uncat')
            .add({
          'name': lastWords,
          'date': DateTime.now().toString(),
        }).whenComplete(() async => await flutterTts.speak('Nota agregada'));
      } else {
        print('op2');
        if(lastWords=='si'){
          print('op3');
          await FirebaseFirestore.instance
              .collection('rec_mar')
              .doc('listas')
              .collection('uncat')
              .add({
            'name': lastWords2,
            'date': DateTime.now().toString(),
          }).whenComplete(() async => await flutterTts.speak('Nota agregada'));
        } else {
          print('op4');
          lastWords2 = lastWords;
          await flutterTts.speak('Nota no agregada ya que el valor es falso, ¿quieres agregarlo como nota final?');
          startListening();
        }

      }
    } catch (onError){
      lastWords = onError.toString();
      print(onError);
      // await flutterTts.speak('Ocurrió un error. El mensaje de error es ' + onError.toString());
    }
  }

  Future<void> startListening() async {

    SpeechToText speech = SpeechToText();
    bool available = await speech.initialize( onStatus: statusListener, onError: errorListener );
    if ( available ) {
      speech.listen( onResult: resultListener );
    }
    else {
      print("The user has denied the use of speech recognition.");
    }

    // lastWords = "";
    // lastError = "";
    // speech.listen(
    //     onResult: resultListener,
    //     listenFor: Duration(seconds: 10),
    //     localeId: _currentLocaleId,
    //     onSoundLevelChange: soundLevelListener,
    //     cancelOnError: true,
    //     partialResults: true,
    //     onDevice: true,
    //     listenMode: ListenMode.confirmation).whenComplete(() => print(speech.lastRecognizedWords));
    // setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords} - ${result.finalResult}";
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    // print(
    // "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

  _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }
}
