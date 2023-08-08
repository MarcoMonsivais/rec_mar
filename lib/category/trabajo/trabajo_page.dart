import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec_mar/category/trabajo/trabajo_detail.dart';
import 'package:rec_mar/global.dart';

class TrabajoPage extends StatefulWidget {

  TrabajoPage();

  @override
  State<TrabajoPage> createState() => _TrabajoPageState();

}

class _TrabajoPageState extends State<TrabajoPage> {

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Column(
                  children: [
                    Text('Agrega el nombre'),
                    TextFormField(
                      controller: _controller,
                    ),
                    TextFormField(
                      controller: _description,
                    )
                  ],
                ),
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
                            child: Text('Aceptar'),
                            onPressed: () {

                              FirebaseFirestore.instance
                                  .collection('rec_mar')
                                  .doc('listas')
                                  .collection('category')
                                  .doc('trabajo')
                                  .collection('items').doc(_controller.text).set({
                                'description': _description.text,
                                'lastupdate': DateTime.now().toString()
                              }).whenComplete(() {

                                _description.clear();
                                _controller.clear();

                                Navigator.of(context).pop();
                                setState(() {});

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
        },
        child: const Icon(Icons.add),
      ),
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
                    borderRadius: BorderRadius.all(Radius.circular(40.0))
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: FutureBuilder<QuerySnapshot>(
                            future: FirebaseFirestore.instance
                                .collection('rec_mar')
                                .doc('listas')
                                .collection('category')
                                .doc('trabajo')
                                .collection('items')
                                .orderBy('lastupdate', descending: true)
                                .get(),
                            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                              if(snapshot.hasData) {
                                for (var i = 0; i < snapshot.data!.docs.length; ++i) {
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
                                                  // _Confirmation(ds.id);
                                                },
                                                child: Card(
                                                  elevation: 5,
                                                  child: ListTile(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TrabajoDetailPage(
                                                                      ds.id)));
                                                    },
                                                    title: Text(ds.id,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                    subtitle: Row(
                                                      children: <Widget>[
                                                        const Icon(
                                                            Icons.date_range,
                                                            color:
                                                                Colors.black54,
                                                            size: 15),
                                                        const SizedBox(
                                                            width: 5.0),
                                                        Text(ds['lastupdate'])
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
                ),
              ),
            ),
          ],
        )
    );
  }

}