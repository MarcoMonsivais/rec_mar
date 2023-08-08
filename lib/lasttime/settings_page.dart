import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rec_mar/global_fun.dart';

class SettingLastTimePage extends StatefulWidget {

  @override
  State<SettingLastTimePage> createState() => _SettingLastTimePageState();

}

class _SettingLastTimePageState extends State<SettingLastTimePage> {

  TextEditingController _countController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emojiController = TextEditingController();
  TextEditingController _messageNotificationController = TextEditingController();
  TextEditingController _timeNotificationController = TextEditingController();

  String today = '';

  @override
  void initState() {
    // TODO: implement initState

    today = DateFormat('yyyy-MM-dd').format(DateTime.now());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [

            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/backgrounds/back-1.jpg"),
                  fit: BoxFit.cover))),

            Center(
              child: Container(
                margin: const EdgeInsets.all(10.0),
                height: MediaQuery.of(context).size.height * 0.85,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(40.0))
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[

                    GestureDetector(
                      onTap: (){
                        setState((){});
                        const snackBar = SnackBar(
                          content: Text('Actualizado'),
                          backgroundColor: (Colors.black12),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        // FirebaseFirestore.instance
                        //   .collection('rec_mar')
                        //   .doc('listas')
                        //   .collection('lastime')
                        //   .snapshots().forEach((element) {
                        //     element.docs.forEach((element) {
                        //       FirebaseFirestore.instance
                        //         .collection('rec_mar')
                        //         .doc('listas')
                        //         .collection('lastime').doc(element.id).update({
                        //           'emoji': '>:v',
                        //           'messageNotification': 'olas',
                        //           'timeNotification': '18:25:01.123456'
                        //       });
                        //     });
                        // }).whenComplete(() => print('Completado'));

                        // FirebaseFirestore.instance
                        //     .collection('rec_mar')
                        //     .doc('listas')
                        //     .collection('lastime').doc('Qdziq5icE5CYnCVPMxZE').update({
                        //   'emoji': '>:v',
                        //   'messageNotification': 'olas',
                        //   'timeNotification': '18:25:01.123456'
                        // }).whenComplete(() => print('Completado'));

                      },
                      child: Text(
                        'Configuración',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),

                    const Divider(height: 2.0, thickness: 2.0,),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25.0, left: 5.0, right: 5.0),
                        child: FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('rec_mar')
                                .doc('listas')
                                .collection('lastime').orderBy('date', descending: true)
                                .get(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                              if(snapshot.hasData){
                                for (var i = 0; i < snapshot.data!.docs.length; ++i) {
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {

                                      DocumentSnapshot<Object?>? ds = snapshot.data!.docs[index];

                                      return ExpansionTile(
                                          textColor: Colors.black,
                                          iconColor: Colors.black,
                                          leading: Text(ds['emoji']),
                                          title: Text(ds['name']),
                                          children: <Widget>[

                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                Text('ID: ${ds.id}'),
                                            ],),

                                            Row(children: [
                                              const Text('Veces: '),
                                              Expanded(child: TextField(
                                                controller: _countController,
                                                keyboardType: TextInputType.name,
                                                textCapitalization: TextCapitalization.sentences,
                                                decoration: InputDecoration(
                                                  labelText: ds['count'].toString(),
                                                  labelStyle: const TextStyle(color: Colors.black),
                                                ),
                                              ))
                                            ],),

                                            Row(children: [
                                              Text('Emoji: '),
                                              Expanded(child: TextField(
                                                controller: _emojiController,
                                                keyboardType: TextInputType.name,
                                                textCapitalization: TextCapitalization.sentences,
                                                decoration: InputDecoration(
                                                  labelText: ds['emoji'],
                                                  labelStyle: const TextStyle(color: Colors.black),
                                                ),
                                              ))
                                            ],),

                                            Row(children: [
                                              Text('Message: '),
                                              Expanded(child: TextField(
                                                controller: _messageNotificationController,
                                                keyboardType: TextInputType.name,
                                                textCapitalization: TextCapitalization.sentences,
                                                decoration: InputDecoration(
                                                  labelText: ds['messageNotification'],
                                                  labelStyle: const TextStyle(color: Colors.black),
                                                ),
                                              ))
                                            ],),

                                            Row(children: [
                                              Text('Time: '),
                                              Expanded(child: TextField(
                                                controller: _timeNotificationController,
                                                keyboardType: TextInputType.name,
                                                textCapitalization: TextCapitalization.sentences,
                                                decoration: InputDecoration(
                                                  labelText: ds['timeNotification'],
                                                  labelStyle: const TextStyle(color: Colors.black),
                                                ),
                                              ))
                                            ],),

                                            GestureDetector(
                                              onTap: (){
                                                FirebaseFirestore.instance
                                                    .collection('rec_mar')
                                                    .doc('listas')
                                                    .collection('lastime').doc(ds.id).update({

                                                  'count': ds['count'],
                                                  'date': ds['date'],
                                                  'name': ds['name'],

                                                  'emoji': ds['emoji'].toString().isEmpty
                                                      ? _emojiController.text
                                                      : _emojiController.text.isEmpty
                                                        ? ds['emoji']
                                                        : _emojiController.text,
                                                  'messageNotification': ds['messageNotification'].toString().isEmpty
                                                      ? _messageNotificationController.text
                                                      :_messageNotificationController.text.isEmpty
                                                        ? ds['messageNotification']
                                                        : _messageNotificationController.text,
                                                  'timeNotification': ds['timeNotification'].toString().isEmpty
                                                      ? _timeNotificationController.text
                                                      : _timeNotificationController.text.isEmpty
                                                        ? ds['timeNotification']
                                                        : _timeNotificationController.text,
                                                }).whenComplete(() {

                                                  _emojiController.clear();
                                                  _nameController.clear();
                                                  _messageNotificationController.clear();
                                                  _timeNotificationController.clear();
                                                  FocusScope.of(context).unfocus();
                                                  showMyDialog('Actualizado', context);
                                                  setState((){});

                                                });
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.all(10.0),
                                                height: 45,
                                                width: MediaQuery.of(context).size.width * 0.85,
                                                decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0))
                                                ),
                                                child: const Center(child: Text('Actualizar', style: TextStyle(color: Colors.white),))
                                              ),
                                            ),

                                          ],
                                        );

                                    });
                                }
                              }

                              if(snapshot.connectionState == ConnectionState.waiting){
                                return const Center(child: CircularProgressIndicator(),);
                              }

                              return const Text('Cargando');
                            }
                        ),
                      ),
                    )

                  ],
                )
              ),
            ),
          ],
        )
    );
  }

}