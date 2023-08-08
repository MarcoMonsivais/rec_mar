import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:rec_mar/category/trabajo/trabajo_unique.dart';
import 'package:rec_mar/global.dart';

class TrabajoDetailPage extends StatefulWidget {

  final String id;

  TrabajoDetailPage(this.id,);

  @override
  State<TrabajoDetailPage> createState() => _TrabajoDetailPageState();

}

class _TrabajoDetailPageState extends State<TrabajoDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: UniqueKey(),
        body: Stack(
          children: [

            Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/backgrounds/back-1.jpg"),
                        fit: BoxFit.cover))
            ),

            Center(
              child: Container(
                  margin: const EdgeInsets.all(10.0),
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(40.0))
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[

                      GestureDetector(
                        onTap: (){
                          setState(() {

                          });
                        },
                        child: Text(
                          'Tareas',
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),

                      const Divider(height: 2.0, thickness: 2.0,),

                      Expanded( child:
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('rec_mar')
                                  .doc('listas')
                                  .collection('category')
                                  .doc('trabajo')
                                  .collection('items')
                                  .doc(widget.id).collection('pendientes')
                                  .get(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                                if(snapshot.hasData){
                                  for (var i = 0;
                                      i < snapshot.data!.docs.length;
                                      ++i) {
                                    return SingleChildScrollView(
                                      child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot<Object?>? ds =
                                                snapshot.data!.docs[index];

                                            return Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 2,
                                                    top: 2,
                                                    left: 15,
                                                    right: 15),
                                                child: Dismissible(
                                                  key: UniqueKey(),
                                                  background: Container(
                                                      color: Colors.red),
                                                  onDismissed: (direction) {
                                                    _Confirmation(ds);
                                                  },
                                                  child: Card(
                                                    elevation: 5,
                                                    child: ListTile(
                                                      onTap: () {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => TrabajoUniquePage(ds.reference)));
                                                      },
                                                      title: Text(ds['name'],
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          const Icon(
                                                              Icons.date_range,
                                                              color: Colors
                                                                  .black54,
                                                              size: 15),
                                                          const SizedBox(
                                                              width: 5.0),
                                                          Text(ds['date'])
                                                        ],
                                                      ),
                                                      // trailing: Text('5'),
                                                    ),
                                                  ),
                                                ));
                                          }),
                                    );
                                  }
                                }

                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return const Center(child: CircularProgressIndicator(),);
                                }

                                return const Center(child: Text('Sin datos'));
                              }
                          ),
                        ),
                      ),

                      const Divider(height: 2.0, thickness: 2.0,),

                      Expanded( child:
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('rec_mar')
                                  .doc('listas')
                                  .collection('category')
                                  .doc('trabajo')
                                  .collection('items')
                                  .doc(widget.id).collection('terminadas')
                                  .get(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                                if(snapshot.hasData) {
                                  for (var i = 0;
                                      i < snapshot.data!.docs.length;
                                      ++i) {
                                    return SingleChildScrollView(
                                      child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot<Object?>? ds =
                                                snapshot.data!.docs[index];

                                            return Container(
                                                padding: const EdgeInsets.only(
                                                    bottom: 2,
                                                    top: 2,
                                                    left: 15,
                                                    right: 15),
                                                child: Dismissible(
                                                  key: UniqueKey(),
                                                  background: Container(
                                                      color: Colors.red),
                                                  onDismissed: (direction) {
                                                    _Confirmation(ds);
                                                  },
                                                  child: Card(
                                                    elevation: 5,
                                                    child: ListTile(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    TrabajoUniquePage(
                                                                        ds.reference)));
                                                      },
                                                      title: Text(ds['name'],
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          const Icon(
                                                              Icons.date_range,
                                                              color: Colors
                                                                  .black54,
                                                              size: 15),
                                                          const SizedBox(
                                                              width: 5.0),
                                                          Text(ds['date'])
                                                        ],
                                                      ),
                                                      // trailing: Text('5'),
                                                    ),
                                                  ),
                                                ));
                                          }),
                                    );
                                  }
                                }

                                if(snapshot.connectionState == ConnectionState.waiting){
                                  return const Center(child: CircularProgressIndicator(),);
                                }

                                return const Center(child: Text('Sin datos'));
                              }
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ],
        )
    );
  }

  //Functions
  Future<void> _Confirmation(DocumentSnapshot ds) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Deseas eliminar?'),
          actions: <Widget>[
            SizedBox(child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  TextButton(
                    child: Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {

                      });
                    },
                  ),

                  TextButton(
                      child: Text('Eliminar'),
                      onPressed: () async {

                        await FirebaseFirestore.instance
                            .collection('rec_mar')
                            .doc('listas')
                            .collection('category')
                            .doc('trabajo')
                            .collection('items')
                            .doc(widget.id).collection('terminadas').doc(ds.id).delete().whenComplete((){
                          Navigator.of(context).pop();
                          setState(() {

                          });
                        });

                      }
                  ),

                  TextButton(
                      child: Text('Mover'),
                      onPressed: () async {

                        await FirebaseFirestore.instance
                            .collection('rec_mar')
                            .doc('listas')
                            .collection('category')
                            .doc('trabajo')
                            .collection('items')
                            .doc(widget.id).collection('terminadas').doc(ds.id).set({
                          'code': '',
                          'date': ds['date'],
                          'description': ds['description'],
                          'name': ds['name']
                        }).whenComplete((){
                          FirebaseFirestore.instance
                              .collection('rec_mar')
                              .doc('listas')
                              .collection('category')
                              .doc('trabajo')
                              .collection('items')
                              .doc(widget.id).collection('pendientes').doc(ds.id).delete().whenComplete((){
                            Navigator.of(context).pop();
                            setState(() {

                            });
                          });
                        });

                      }
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

}