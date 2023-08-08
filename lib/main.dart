import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rec_mar/global.dart' as Globals;
import 'package:rec_mar/src/homepage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AwesomeNotifications().actionStream.listen((event) async {
    print('-----------------------------------------------------------');
    print('event received!');
    print(event.toMap().toString());
    print(event.buttonKeyInput);
    print('-----------------------------------------------------------');
    String date = DateTime.now().toString().substring(0, DateTime.now().toString().indexOf(' '));

    switch(event.id){
      case 1:
        FirebaseFirestore.instance
          .collection('rec_mar')
          .doc('listas')
          .collection('dayToDay')
          .doc(DateTime.now().toString().substring(0, DateTime.now().toString().indexOf(' ')))
          .get().then((value) async {
            DocumentSnapshot ds = value;
            await FirebaseFirestore.instance
                .collection('rec_mar')
                .doc('listas')
                .collection('dayToDay')
                .doc(date)
                .update({
              'desayuno': ds['desayuno'].toString().isEmpty
                  ? ''
                  : ds['desayuno'],
              'almuerzo': event.buttonKeyInput,
              'comida': ds['comida'].toString().isEmpty
                  ? ''
                  : ds['comida'],
              'merienda': ds['merienda'].toString().isEmpty
                  ? ''
                  : ds['merienda'],
              'cena': ds['cena'].toString().isEmpty
                  ? ''
                  : ds['cena'],
              'fumar': ds['fumar'].toString().isEmpty
                  ? ''
                  : ds['fumar'],
              'otro': ds['otro'].toString().isEmpty
                  ? ''
                  : ds['otro'],
            });
        });
        break;
      case 2:
        FirebaseFirestore.instance
            .collection('rec_mar')
            .doc('listas')
            .collection('dayToDay')
            .doc(DateTime.now().toString().substring(0, DateTime.now().toString().indexOf(' ')))
            .get().then((value) async {
          DocumentSnapshot ds = value;
          await FirebaseFirestore.instance
              .collection('rec_mar')
              .doc('listas')
              .collection('dayToDay')
              .doc(date)
              .update({
            'desayuno': ds['desayuno'].toString().isEmpty
                ? ''
                : ds['desayuno'],
            'almuerzo': ds['almuerzo'].toString().isEmpty
                ? ''
                : ds['almuerzo'],
            'comida': event.buttonKeyInput,
            'merienda': ds['merienda'].toString().isEmpty
                ? ''
                : ds['merienda'],
            'cena': ds['cena'].toString().isEmpty
                ? ''
                : ds['cena'],
            'fumar': ds['fumar'].toString().isEmpty
                ? ''
                : ds['fumar'],
            'otro': ds['otro'].toString().isEmpty
                ? ''
                : ds['otro'],
          });
        });
        break;
      case 3:
        FirebaseFirestore.instance
            .collection('rec_mar')
            .doc('listas')
            .collection('dayToDay')
            .doc(DateTime.now().toString().substring(0, DateTime.now().toString().indexOf(' ')))
            .get().then((value) async {
          DocumentSnapshot ds = value;
          await FirebaseFirestore.instance
              .collection('rec_mar')
              .doc('listas')
              .collection('dayToDay')
              .doc(date)
              .update({
            'desayuno': ds['desayuno'].toString().isEmpty
                ? ''
                : ds['desayuno'],
            'almuerzo': ds['almuerzo'].toString().isEmpty
                ? ''
                : ds['almuerzo'],
            'comida': ds['comida'].toString().isEmpty
                ? ''
                : ds['comida'],
            'merienda': ds['merienda'].toString().isEmpty
                ? ''
                : ds['merienda'],
            'cena': event.buttonKeyInput,
            'fumar': ds['fumar'].toString().isEmpty
                ? ''
                : ds['fumar'],
            'otro': ds['otro'].toString().isEmpty
                ? ''
                : ds['otro'],
          });
        });
        break;
    }

  });

  AwesomeNotifications().initialize(
      'resource://drawable/icon',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white),
        NotificationChannel(
          channelGroupKey: 'schedule_tests',
          channelKey: 'scheduled',
          channelName: 'Scheduled notifications',
          channelDescription: 'Notifications with schedule functionality',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Color(0xFF9D50DD),
          vibrationPattern: lowVibrationPattern,
          importance: NotificationImportance.High,
          defaultRingtoneType: DefaultRingtoneType.Alarm,
          criticalAlerts: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(channelGroupkey: 'basic_channel_group', channelGroupName: 'Basic group'),
        NotificationChannelGroup(channelGroupkey: 'schedule_tests', channelGroupName: 'Schedule tests'),
      ],
      debug: true
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Globals.colorsBack CB = Globals.colorsBack();
  final Globals.imagesBack IB = Globals.imagesBack();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'OpenSans'),
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('es', ''), // Spanish, no country code
        ],
        routes: <String, WidgetBuilder>{
            "/home": (BuildContext context) => MomePage(CB, IB),
          }
        );
  }

}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String today = '', tst = '';
  final Globals.colorsBack CB = Globals.colorsBack();
  final Globals.imagesBack IB = Globals.imagesBack();

  _EstablishVariables() async{
    try {

      await FirebaseFirestore.instance
          .collection('rec_mar')
          .doc('main')
          .collection('setting')
          .doc('colors')
          .get()
          .then((val) {
        CB.cardColor = Color(int.parse(val.data()!['card'], radix: 16));
        CB.floatingColor = Color(int.parse(val.data()!['floating'], radix: 16));
        CB.fondoColor = Color(int.parse(val.data()!['fondo'], radix: 16));
        CB.letraColor = Color(int.parse(val.data()!['letra'], radix: 16));
      });

      await FirebaseFirestore.instance
          .collection('rec_mar')
          .doc('main')
          .collection('setting')
          .doc('images')
          .get()
          .then((val) {
        IB.fondoImage = val.data()!['fondo'];
        IB.splashImage = val.data()!['splash'];
      });

    }
    catch (onError){
      print('Error: ' + onError.toString());
    }
  }

  @override
  void initState() {
    today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _EstablishVariables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Timer(const Duration(seconds: 2), () async {

      // FirebaseFirestore.instance
      //   .collection('rec_mar')
      //   .doc('listas')
      //   .collection('dayToDay')
      //   .doc(DateTime.now().subtract(const Duration(days: 1)).toString().substring(0, DateTime.now().subtract(const Duration(days: 1)).toString().indexOf(' ')))
      //   .get().then((value) async {

      //   AwesomeNotifications().createNotification(
      //     schedule: NotificationCalendar.fromDate(date: DateTime.parse(today + ' 10:15:00.012345')),
      //     content: NotificationContent(
      //       id: 1,
      //       channelKey: 'basic_channel',
      //       title: 'Almuerzo',
      //       body: value['almuerzo'].toString().isEmpty ? 'Ayer no almorzaste:0 que no se te pase hoy uwu' : 'Ayer almorzaste: ' + value['almuerzo'],
      //       wakeUpScreen: true,
      //       category: NotificationCategory.Message,
      //       autoDismissible: false,
      //       hideLargeIconOnExpand: true,
      //     ),
      //     actionButtons: [
      //       NotificationActionButton(
      //           key: 'REPLY',
      //           label: '¿Qué almorzarás hoy?',
      //           enabled: true,
      //           buttonType: ActionButtonType.InputField,
      //           icon: 'asset://assets/icon-app.png'
      //       )
      //     ],
      //   ).whenComplete(() => print('creada 1'));

      //   AwesomeNotifications().createNotification(
      //     schedule: NotificationCalendar.fromDate(date: DateTime.parse(today + ' 12:15:00.012345')),
      //     content: NotificationContent(
      //       id: 2,
      //       channelKey: 'basic_channel',
      //       title: 'Hora de comer',
      //       body: value['comida'].toString().isEmpty ? 'OBVIAMENTE si comiste ayer, pero no lo registraste xD' : 'Ayer comiste: ' + value['comida'],
      //       wakeUpScreen: true,
      //       category: NotificationCategory.Message,
      //       autoDismissible: false,
      //       hideLargeIconOnExpand: true,
      //     ),
      //     actionButtons: [
      //       NotificationActionButton(
      //           key: 'REPLY',
      //           label: '¿Qué comerás hoy?',
      //           enabled: true,
      //           buttonType: ActionButtonType.InputField,
      //           icon: 'asset://assets/icon-app.png'
      //       )
      //     ],
      //   ).whenComplete(() => print('creada 2'));

      //   AwesomeNotifications().createNotification(
      //     schedule: NotificationCalendar.fromDate(date: DateTime.parse(today + ' 19:15:00.012345')),
      //     content: NotificationContent(
      //       id: 3,
      //       channelKey: 'basic_channel',
      //       title: 'Hora de cenar',
      //       body: value['cenar'].toString().isEmpty ? 'Ayer no cenaste >:v ponte las pilas rey' : 'Ayer cenaste: ' + value['cenar'],
      //       wakeUpScreen: true,
      //       category: NotificationCategory.Message,
      //       autoDismissible: false,
      //       hideLargeIconOnExpand: true,
      //     ),
      //     actionButtons: [
      //       NotificationActionButton(
      //           key: 'REPLY',
      //           label: '¿Qué cenarás hoy?',
      //           enabled: true,
      //           buttonType: ActionButtonType.InputField,
      //           icon: 'asset://assets/icon-app.png'
      //       )
      //     ],
      //   ).whenComplete(() => print('creada 3'));

      // });

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MomePage(CB, IB)));
          
    });

    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/image-batman.jpeg'),
                fit: BoxFit.fitWidth)
        )
    );
  }

}